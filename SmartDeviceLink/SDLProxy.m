// SDLProxy.m

#import "SDLProxy.h"

#import <ExternalAccessory/ExternalAccessory.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "SDLAbstractTransport.h"
#import "SDLAudioStreamingState.h"
#import "SDLLogMacros.h"
#import "SDLEncodedSyncPData.h"
#import "SDLFileType.h"
#import "SDLFunctionID.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLLanguage.h"
#import "SDLLayoutMode.h"
#import "SDLLockScreenStatusManager.h"

#import "SDLOnHMIStatus.h"
#import "SDLOnSystemRequest.h"
#import "SDLPolicyDataParser.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPutFile.h"
#import "SDLRPCPayload.h"
#import "SDLRPCResponse.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRequestType.h"
#import "SDLStreamingMediaManager.h"
#import "SDLSystemContext.h"
#import "SDLSystemRequest.h"
#import "SDLTimer.h"
#import "SDLVehicleType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLVehicleMake;

typedef void (^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);
typedef void (^URLSessionDownloadTaskCompletionHandler)(NSURL *location, NSURLResponse *response, NSError *error);

NSString *const SDLProxyVersion = @"5.2.0";
const float StartSessionTime = 10.0;
const float NotifyProxyClosedDelay = (float)0.1;
const int PoliciesCorrelationId = 65535;
static float DefaultConnectionTimeout = 45.0;

@interface SDLProxy () {
    SDLLockScreenStatusManager *_lsm;
}

@property (copy, nonatomic) NSString *appId;
@property (strong, nonatomic) NSMutableSet<NSObject<SDLProxyListener> *> *mutableProxyListeners;
@property (nullable, nonatomic, strong) SDLDisplayCapabilities *displayCapabilities;
@property (nonatomic, strong) NSMutableDictionary<SDLVehicleMake *, Class> *securityManagers;
@property (nonatomic, strong) NSURLSession* urlSession;
@property (strong, nonatomic) dispatch_queue_t rpcProcessingQueue;

@end


@implementation SDLProxy

#pragma mark - Object lifecycle
- (instancetype)initWithTransport:(SDLAbstractTransport *)transport protocol:(SDLAbstractProtocol *)protocol delegate:(NSObject<SDLProxyListener> *)theDelegate {
    if (self = [super init]) {
        SDLLogD(@"Framework Version: %@", self.proxyVersion);
        _debugConsoleGroupName = @"default";
        _lsm = [[SDLLockScreenStatusManager alloc] init];
        _rpcProcessingQueue = dispatch_queue_create("com.sdl.rpcProcessingQueue", DISPATCH_QUEUE_SERIAL);

        _mutableProxyListeners = [NSMutableSet setWithObject:theDelegate];
        _securityManagers = [NSMutableDictionary dictionary];
        _protocol = protocol;
        _transport = transport;
        _transport.delegate = protocol;
        [_protocol.protocolDelegateTable addObject:self];
        _protocol.transport = transport;

        [self.transport connect];

        SDLLogV(@"Proxy transport initialization");
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
        
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = DefaultConnectionTimeout;
        configuration.timeoutIntervalForResource = DefaultConnectionTimeout;
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        _urlSession = [NSURLSession sessionWithConfiguration:configuration];

    }

    return self;
}

- (void)dealloc {
    if (self.protocol.securityManager != nil) {
        [self.protocol.securityManager stop];
    }

    if (self.transport != nil) {
        [self.transport disconnect];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
    
    [_urlSession invalidateAndCancel];
    SDLLogV(@"Proxy dealloc");
}

- (void)notifyProxyClosed {
    if (_isConnected) {
        _isConnected = NO;
        [self invokeMethodOnDelegates:@selector(onProxyClosed) withObject:nil];
    }
}


#pragma mark - Application Lifecycle

- (void)sendMobileHMIState {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sdl_sendMobileHMIState];
    });
}

- (void)sdl_sendMobileHMIState {
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    SDLOnHMIStatus *HMIStatusRPC = [[SDLOnHMIStatus alloc] init];

    HMIStatusRPC.audioStreamingState = SDLAudioStreamingStateNotAudible;
    HMIStatusRPC.systemContext = SDLSystemContextMain;

    switch (appState) {
        case UIApplicationStateActive: {
            HMIStatusRPC.hmiLevel = SDLHMILevelFull;
        } break;
        case UIApplicationStateBackground: // Fallthrough
        case UIApplicationStateInactive: {
            HMIStatusRPC.hmiLevel = SDLHMILevelBackground;
        } break;
        default: break;
    }

    SDLLogD(@"Mobile UIApplication state changed, sending to remote system: %@", HMIStatusRPC.hmiLevel);
    [self sendRPC:HMIStatusRPC];
}

#pragma mark - Accessors

- (NSSet<NSObject<SDLProxyListener> *> *)proxyListeners {
    return [self.mutableProxyListeners copy];
}


#pragma mark - Setters / Getters

- (NSString *)proxyVersion {
    return SDLProxyVersion;
}

#pragma mark - SecurityManager

- (void)addSecurityManagers:(NSArray<Class> *)securityManagerClasses forAppId:(NSString *)appId {
    NSParameterAssert(securityManagerClasses != nil);
    NSParameterAssert(appId != nil);
    self.appId = appId;

    for (Class securityManagerClass in securityManagerClasses) {
        if (![securityManagerClass conformsToProtocol:@protocol(SDLSecurityType)]) {
            NSString *reason = [NSString stringWithFormat:@"Invalid security manager: Class %@ does not conform to SDLSecurityType protocol", NSStringFromClass(securityManagerClass)];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
        }

        NSSet<NSString *> *vehicleMakes = [securityManagerClass availableMakes];

        if (vehicleMakes == nil || vehicleMakes.count == 0) {
            NSString *reason = [NSString stringWithFormat:@"Invalid security manager: Failed to retrieve makes for class %@", NSStringFromClass(securityManagerClass)];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
        }

        for (NSString *vehicleMake in vehicleMakes) {
            self.securityManagers[vehicleMake] = securityManagerClass;
        }
    }
}

- (nullable id<SDLSecurityType>)securityManagerForMake:(NSString *)make {
    if ((make != nil) && (self.securityManagers[make] != nil)) {
        Class securityManagerClass = self.securityManagers[make];
        self.protocol.appId = self.appId;
        return [[securityManagerClass alloc] init];
    }

    return nil;
}


#pragma mark - SDLProtocolListener Implementation

- (void)onProtocolOpened {
    _isConnected = YES;
    SDLLogV(@"Proxy RPC protocol opened");
    // The RPC payload will be created by the protocol object...it's weird and confusing, I know.
    [self.protocol startServiceWithType:SDLServiceTypeRPC payload:nil];

    if (self.startSessionTimer == nil) {
        self.startSessionTimer = [[SDLTimer alloc] initWithDuration:StartSessionTime repeat:NO];
        __weak typeof(self) weakSelf = self;
        self.startSessionTimer.elapsedBlock = ^{
            SDLLogW(@"Start session timed out");
            [weakSelf performSelector:@selector(notifyProxyClosed) withObject:nil afterDelay:NotifyProxyClosedDelay];
        };
    }
    [self.startSessionTimer start];
}

- (void)onProtocolClosed {
    [self notifyProxyClosed];
}

- (void)onError:(NSString *)info exception:(NSException *)e {
    [self invokeMethodOnDelegates:@selector(onError:) withObject:e];
}

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    // Turn off the timer, the start session response came back
    [self.startSessionTimer cancel];
    SDLLogV(@"StartSession (response)\nSessionId: %d for serviceType %d", startServiceACK.header.sessionID, startServiceACK.header.serviceType);

    if (startServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self invokeMethodOnDelegates:@selector(onProxyOpened) withObject:nil];
    }
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msgData {
    @try {
        [self handleProtocolMessage:msgData];
    } @catch (NSException *e) {
        SDLLogW(@"Proxy: Failed to handle protocol message %@", e);
    }
}


#pragma mark - Message sending and recieving
- (void)sendRPC:(SDLRPCMessage *)message {
    @try {
        [self.protocol sendRPC:message];
    } @catch (NSException *exception) {
        SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
    }
}

- (void)handleProtocolMessage:(SDLProtocolMessage *)incomingMessage {
    // Convert protocol message to dictionary
    NSDictionary<NSString *, id> *rpcMessageAsDictionary = [incomingMessage rpcDictionary];
    [self handleRPCDictionary:rpcMessageAsDictionary];
}

- (void)handleRPCDictionary:(NSDictionary<NSString *, id> *)dict {
    SDLRPCMessage *message = [[SDLRPCMessage alloc] initWithDictionary:[dict mutableCopy]];
    NSString *functionName = [message getFunctionName];
    NSString *messageType = [message messageType];

    // If it's a response, append response
    if ([messageType isEqualToString:SDLNameResponse]) {
        BOOL notGenericResponseMessage = ![functionName isEqualToString:@"GenericResponse"];
        if (notGenericResponseMessage) {
            functionName = [NSString stringWithFormat:@"%@Response", functionName];
        }
    }

    // From the function name, create the corresponding RPCObject and initialize it
    NSString *functionClassName = [NSString stringWithFormat:@"SDL%@", functionName];
    SDLRPCMessage *newMessage = [[NSClassFromString(functionClassName) alloc] initWithDictionary:[dict mutableCopy]];

    // Log the RPC message
    SDLLogV(@"Message received: %@", newMessage);

    // Intercept and handle several messages ourselves
    if ([functionName isEqualToString:SDLNameOnAppInterfaceUnregistered] || [functionName isEqualToString:SDLNameUnregisterAppInterface]) {
        [self handleRPCUnregistered:dict];
    }

    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
        [self handleRegisterAppInterfaceResponse:(SDLRPCResponse *)newMessage];
    }

    if ([functionName isEqualToString:@"OnEncodedSyncPData"]) {
        [self handleSyncPData:newMessage];
    }

    if ([functionName isEqualToString:@"OnSystemRequest"]) {
        [self handleSystemRequest:dict];
    }

    if ([functionName isEqualToString:@"SystemRequestResponse"]) {
        [self handleSystemRequestResponse:newMessage];
    }

    // Formulate the name of the method to call and invoke the method on the delegate(s)
    NSString *handlerName = [NSString stringWithFormat:@"on%@:", functionName];
    SEL handlerSelector = NSSelectorFromString(handlerName);
    [self invokeMethodOnDelegates:handlerSelector withObject:newMessage];

    // When an OnHMIStatus notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnHMIStatus"]) {
        [self handleAfterHMIStatus:newMessage];
    }

    // When an OnDriverDistraction notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnDriverDistraction"]) {
        [self handleAfterDriverDistraction:newMessage];
    }
}


#pragma mark - RPC Handlers

- (void)handleRPCUnregistered:(NSDictionary<NSString *, id> *)messageDictionary {
    SDLLogW(@"Unregistration forced by module. %@", messageDictionary);
    [self notifyProxyClosed];
}

- (void)handleRegisterAppInterfaceResponse:(SDLRPCResponse *)response {
    SDLRegisterAppInterfaceResponse *registerResponse = (SDLRegisterAppInterfaceResponse *)response;

    self.protocol.securityManager = [self securityManagerForMake:registerResponse.vehicleType.make];
    if (self.protocol.securityManager && [self.protocol.securityManager respondsToSelector:@selector(setAppId:)]) {
        self.protocol.securityManager.appId = self.appId;
    }

    if ([SDLGlobals sharedGlobals].majorProtocolVersion >= 4) {
        [self sendMobileHMIState];
        // Send SDL updates to application state
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMobileHMIState) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMobileHMIState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (void)handleSyncPData:(SDLRPCMessage *)message {
    // If URL != nil, perform HTTP Post and don't pass the notification to proxy listeners
    SDLLogV(@"OnEncodedSyncPData: %@", message);

    NSString *urlString = (NSString *)[message getParameters:@"URL"];
    NSDictionary<NSString *, id> *encodedSyncPData = (NSDictionary<NSString *, id> *)[message getParameters:@"data"];
    NSNumber *encodedSyncPTimeout = (NSNumber *)[message getParameters:@"Timeout"];

    if (urlString && encodedSyncPData && encodedSyncPTimeout) {
        [self sendEncodedSyncPData:encodedSyncPData toURL:urlString withTimeout:encodedSyncPTimeout];
    }
}

- (void)handleSystemRequest:(NSDictionary<NSString *, id> *)dict {
    SDLLogV(@"OnSystemRequest");

    SDLOnSystemRequest *systemRequest = [[SDLOnSystemRequest alloc] initWithDictionary:[dict mutableCopy]];
    SDLRequestType requestType = systemRequest.requestType;

    // Handle the various OnSystemRequest types
    if ([requestType isEqualToEnum:SDLRequestTypeProprietary]) {
        [self handleSystemRequestProprietary:systemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeLockScreenIconURL]) {
        [self handleSystemRequestLockScreenIconURL:systemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeHTTP]) {
        [self sdl_handleSystemRequestHTTP:systemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeLaunchApp]) {
        [self sdl_handleSystemRequestLaunchApp:systemRequest];
    }
}

- (void)handleSystemRequestResponse:(SDLRPCMessage *)message {
    SDLLogV(@"SystemRequestResponse to be discarded");
}


#pragma mark Handle Post-Invoke of Delegate Methods
- (void)handleAfterHMIStatus:(SDLRPCMessage *)message {
    SDLHMILevel hmiLevel = (SDLHMILevel)[message getParameters:SDLNameHMILevel];
    _lsm.hmiLevel = hmiLevel;

    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self invokeMethodOnDelegates:callbackSelector withObject:_lsm.lockScreenStatusNotification];
}

- (void)handleAfterDriverDistraction:(SDLRPCMessage *)message {
    NSString *stateString = (NSString *)[message getParameters:SDLNameState];
    BOOL state = [stateString isEqualToString:@"DD_ON"] ? YES : NO;
    _lsm.driverDistracted = state;

    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self invokeMethodOnDelegates:callbackSelector withObject:_lsm.lockScreenStatusNotification];
}


#pragma mark OnSystemRequest Handlers
- (void)sdl_handleSystemRequestLaunchApp:(SDLOnSystemRequest *)request {
    NSURL *URLScheme = [NSURL URLWithString:request.url];
    if (URLScheme == nil) {
        SDLLogW(@"System request LaunchApp failed: invalid URL sent from module: %@", request.url);
        return;
    }
    // If system version is less than 9.0 http://stackoverflow.com/a/5337804/1370927
    if (SDL_SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        // Return early if we can't openURL because openURL will crash instead of fail silently in < 9.0
        if (![[UIApplication sharedApplication] canOpenURL:URLScheme]) {
            return;
        }
    }
    [[UIApplication sharedApplication] openURL:URLScheme];
}

- (void)handleSystemRequestProprietary:(SDLOnSystemRequest *)request {
    NSDictionary<NSString *, id> *JSONDictionary = [self validateAndParseSystemRequest:request];
    if (JSONDictionary == nil || request.url == nil) {
        return;
    }

    NSDictionary<NSString *, id> *requestData = JSONDictionary[@"HTTPRequest"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    // Parse and display the policy data.
    SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
    NSData *policyData = [pdp unwrap:bodyData];
    if (policyData != nil) {
        [pdp parsePolicyData:policyData];
        SDLLogV(@"Policy data received");
    }

    // Send the HTTP Request
    __weak typeof(self) weakSelf = self;
    [self uploadForBodyDataDictionary:JSONDictionary
                            URLString:request.url
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         __strong typeof(weakSelf) strongSelf = weakSelf;

                        if (error) {
                            SDLLogW(@"OnSystemRequest HTTP response error: %@", error);
                            return;
                        }

                        if (data == nil || data.length == 0) {
                            SDLLogW(@"OnSystemRequest HTTP response error: no data received");
                            return;
                        }

                        // Create the SystemRequest RPC to send to module.
                        SDLLogV(@"OnSystemRequest HTTP response");
                        SDLSystemRequest *request = [[SDLSystemRequest alloc] init];
                        request.correlationID = [NSNumber numberWithInt:PoliciesCorrelationId];
                        request.requestType = SDLRequestTypeProprietary;
                        request.bulkData = data;

                        // Parse and display the policy data.
                        SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
                        NSData *policyData = [pdp unwrap:data];
                        if (policyData) {
                            [pdp parsePolicyData:policyData];
                            SDLLogV(@"Cloud policy data: %@", pdp);
                        }

                        // Send the RPC Request
                        [strongSelf sendRPC:request];
                    }];
}

- (void)handleSystemRequestLockScreenIconURL:(SDLOnSystemRequest *)request {
	__weak typeof(self) weakSelf = self;
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
					__strong typeof(weakSelf) strongSelf = weakSelf;
                    if (error != nil) {
                        SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
                        return;
                    }
                    
                    UIImage *icon = [UIImage imageWithData:data];
                    [strongSelf invokeMethodOnDelegates:@selector(onReceivedLockScreenIcon:) withObject:icon];
                }];
}

- (void)sdl_handleSystemRequestHTTP:(SDLOnSystemRequest *)request {
    if (request.bulkData.length == 0) {
        // TODO: not sure how we want to handle http requests that don't have bulk data (maybe as GET?)
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self sdl_uploadData:request.bulkData
              toURLString:request.url
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (error != nil) {
                SDLLogW(@"OnSystemRequest (HTTP) error: %@", error.localizedDescription);
                return;
            }

            if (data.length == 0) {
                SDLLogW(@"OnSystemRequest (HTTP) error: no data returned");
                return;
            }

            // Show the HTTP response
            SDLLogV(@"OnSystemRequest (HTTP) response: %@", response);

            // Create the SystemRequest RPC to send to module.
            SDLPutFile *putFile = [[SDLPutFile alloc] init];
            putFile.fileType = SDLFileTypeJSON;
            putFile.correlationID = @(PoliciesCorrelationId);
            putFile.syncFileName = @"response_data";
            putFile.bulkData = data;

            // Send RPC Request
            [strongSelf sendRPC:putFile];
        }];
}

/**
 *  Determine if the System Request is valid and return it's JSON dictionary, if available.
 *
 *  @param request The system request to parse
 *
 *  @return A parsed JSON dictionary, or nil if it couldn't be parsed
 */
- (nullable NSDictionary<NSString *, id> *)validateAndParseSystemRequest:(SDLOnSystemRequest *)request {
    NSString *urlString = request.url;
    SDLFileType fileType = request.fileType;

    // Validate input
    if (urlString == nil || [NSURL URLWithString:urlString] == nil) {
        SDLLogW(@"OnSystemRequest validation failure: URL is nil");
        return nil;
    }

    if (![fileType isEqualToEnum:SDLFileTypeJSON]) {
        SDLLogW(@"OnSystemRequest validation failure: file type is not JSON");
        return nil;
    }

    // Get data dictionary from the bulkData
    NSError *error = nil;
    NSDictionary<NSString *, id> *JSONDictionary = [NSJSONSerialization JSONObjectWithData:request.bulkData options:kNilOptions error:&error];
    if (error != nil) {
        SDLLogW(@"OnSystemRequest validation failure: data is not valid JSON");
        return nil;
    }

    return JSONDictionary;
}

/**
 *  Start an upload for some data to a web address specified
 *
 *  @param data              The data to be passed to the server
 *  @param urlString         The URL the data should be POSTed to
 *  @param completionHandler A completion handler of what to do when the server responds
 */
- (void)sdl_uploadData:(NSData *_Nonnull)data toURLString:(NSString *_Nonnull)urlString completionHandler:(URLSessionTaskCompletionHandler _Nullable)completionHandler {
    // NSURLRequest configuration
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"POST";

    SDLLogV(@"OnSystemRequest (HTTP) upload task created for URL: %@", urlString);

    // Create the upload task
    [self sdl_sendUploadRequest:request withData:data completionHandler:completionHandler];
}

/**
 *  Start an upload for a body data dictionary, this is used by the "proprietary" system request needed for backward compatibility
 *
 *  @param dictionary        The system request dictionary that contains the HTTP data to be sent
 *  @param urlString         A string containing the URL to send the upload to
 *  @param completionHandler A completion handler returning the response from the server to the upload task
 */
- (void)uploadForBodyDataDictionary:(NSDictionary<NSString *, id> *)dictionary URLString:(NSString *)urlString completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    NSParameterAssert(dictionary != nil);
    NSParameterAssert(urlString != nil);
    NSParameterAssert(completionHandler != NULL);

    // Extract data from the dictionary
    NSDictionary<NSString *, id> *requestData = dictionary[@"HTTPRequest"];
    NSDictionary *headers = requestData[@"headers"];
    NSString *contentType = headers[@"ContentType"];
    NSTimeInterval timeout = [headers[@"ConnectTimeout"] doubleValue];
    NSString *method = headers[@"RequestMethod"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    // NSURLRequest configuration
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
    request.timeoutInterval = timeout;
    request.HTTPMethod = method;

    SDLLogV(@"OnSystemRequest (Proprietary) upload task created for URL: %@", urlString);

    // Create the upload task
    [self sdl_sendUploadRequest:request withData:bodyData completionHandler:completionHandler];
}

- (void)sdl_sendUploadRequest:(NSURLRequest*)request withData:(NSData*)data completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    NSMutableURLRequest* mutableRequest = [request mutableCopy];
    
    if ([mutableRequest.URL.scheme isEqualToString:@"http"]) {
        mutableRequest.URL = [NSURL URLWithString:[mutableRequest.URL.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }
    
    [[self.urlSession uploadTaskWithRequest:request fromData:data completionHandler:completionHandler] resume];
}

- (void)sdl_sendDataTaskWithURL:(NSURL*)url completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    if ([url.scheme isEqualToString:@"http"]) {
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }
    
    [[self.urlSession dataTaskWithURL:url completionHandler:completionHandler] resume];
}

#pragma mark - Delegate management

- (void)addDelegate:(NSObject<SDLProxyListener> *)delegate {
    @synchronized(self.mutableProxyListeners) {
        [self.mutableProxyListeners addObject:delegate];
    }
}

- (void)removeDelegate:(NSObject<SDLProxyListener> *)delegate {
    @synchronized(self.mutableProxyListeners) {
        [self.mutableProxyListeners removeObject:delegate];
    }
}

- (void)invokeMethodOnDelegates:(SEL)aSelector withObject:(nullable id)object {
    // Occurs on the protocol receive serial queue
    dispatch_async(_rpcProcessingQueue, ^{
        for (id<SDLProxyListener> listener in self.proxyListeners) {
            if ([listener respondsToSelector:aSelector]) {
                // HAX: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
                ((void (*)(id, SEL, id))[(NSObject *)listener methodForSelector:aSelector])(listener, aSelector, object);
            }
        }
    });
}


#pragma mark - System Request and SyncP handling

- (void)sendEncodedSyncPData:(NSDictionary<NSString *, id> *)encodedSyncPData toURL:(NSString *)urlString withTimeout:(NSNumber *)timeout {
    // Configure HTTP URL & Request
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 60;

    // Prepare the data in the required format
    NSString *encodedSyncPDataString = [[NSString stringWithFormat:@"%@", encodedSyncPData] componentsSeparatedByString:@"\""][1];
    NSArray<NSString *> *array = [NSArray arrayWithObject:encodedSyncPDataString];
    NSDictionary<NSString *, id> *dictionary = @{ @"data": array };
    NSError *JSONSerializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&JSONSerializationError];
    if (JSONSerializationError) {
        SDLLogW(@"Error attempting to create SyncPData for HTTP request: %@", JSONSerializationError);
        return;
    }

    // Send the HTTP Request
    __weak typeof(self) weakSelf = self;
    [[self.urlSession uploadTaskWithRequest:request
                                   fromData:data
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                           [weakSelf syncPDataNetworkRequestCompleteWithData:data response:response error:error];
                                       }] resume];

    SDLLogV(@"OnEncodedSyncPData (HTTP Request)");
}

// Handle the OnEncodedSyncPData HTTP Response
- (void)syncPDataNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    // Sample of response: {"data":["SDLKGLSDKFJLKSjdslkfjslkJLKDSGLKSDJFLKSDJF"]}
    SDLLogV(@"OnEncodedSyncPData (HTTP Response): %@", response);

    // Validate response data.
    if (data == nil || data.length == 0) {
        SDLLogW(@"OnEncodedSyncPData (HTTP Response): no data returned");
        return;
    }

    // Convert data to RPCRequest
    NSError *JSONConversionError = nil;
    NSDictionary<NSString *, id> *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONConversionError];
    if (!JSONConversionError) {
        SDLEncodedSyncPData *request = [[SDLEncodedSyncPData alloc] init];
        request.correlationID = [NSNumber numberWithInt:PoliciesCorrelationId];
        request.data = [responseDictionary objectForKey:@"data"];

        [self sendRPC:request];
    }
}


#pragma mark - PutFile Streaming
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest {
    inputStream.delegate = self;
    objc_setAssociatedObject(inputStream, @"SDLPutFile", putFileRPCRequest, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(inputStream, @"BaseOffset", [putFileRPCRequest offset], OBJC_ASSOCIATION_RETAIN);

    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            // Grab some bytes from the stream and send them in a SDLPutFile RPC Request
            NSUInteger currentStreamOffset = [[stream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedIntegerValue];

            NSMutableData *buffer = [NSMutableData dataWithLength:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
            NSInteger nBytesRead = [(NSInputStream *)stream read:(uint8_t *)buffer.mutableBytes maxLength:buffer.length];
            if (nBytesRead > 0) {
                NSData *data = [buffer subdataWithRange:NSMakeRange(0, (NSUInteger)nBytesRead)];
                NSUInteger baseOffset = [(NSNumber *)objc_getAssociatedObject(stream, @"BaseOffset") unsignedIntegerValue];
                NSUInteger newOffset = baseOffset + currentStreamOffset;

                SDLPutFile *putFileRPCRequest = (SDLPutFile *)objc_getAssociatedObject(stream, @"SDLPutFile");
                [putFileRPCRequest setOffset:[NSNumber numberWithUnsignedInteger:newOffset]];
                [putFileRPCRequest setLength:[NSNumber numberWithUnsignedInteger:(NSUInteger)nBytesRead]];
                [putFileRPCRequest setBulkData:data];

                [self sendRPC:putFileRPCRequest];
            }

            break;
        }
        case NSStreamEventEndEncountered: {
            // Cleanup the stream
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

            break;
        }
        case NSStreamEventErrorOccurred: {
            SDLLogE(@"NSStream error attempting to upload putfile stream: %lu", (unsigned long)eventCode);
            break;
        }
        default: {
            break;
        }
    }
}

@end

NS_ASSUME_NONNULL_END
