//
//  SDLProxyBase.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLProxyBase.h"
#import "SDLSession.h"
#import "SDLConnectionState.h"
#import "SDLInterfaceAvailability.h"
#import "SDLConnectionDelegate.h"
#import "SDLBaseTransportConfig.h"
#import "SDLNames.h"
#import "SDLFunctionID.h"
#import "SDLJsonEncoder.h"
#import "SDLJsonDecoder.h"
#import "SDLRPCMessageType.h"
#import "SDLProxyMessageDispatcher.h"
#import "SDLRPCMessage.h"
#import "SDLSystemRequest.h"
#import "SDLInternalProxyMessage.h"
#import "SDLOnError.h"
#import "SDLMessageType.h"
#import "SDLSystemRequestResponse.h"
#import "SDLHeartbeatMonitor.h"
#import "SDLOnProxyClosed.h"

@import ExternalAccessory;

static int const PROX_PROT_VER_ONE = 1;
static int const REGISTER_APP_INTERFACE_CORRELATION_ID = 65529;
static int const UNREGISTER_APP_INTERFACE_CORRELATION_ID = 65530;
static int const HEARTBEAT_CORRELATION_ID = 65531;
static int const POLICIES_CORRELATION_ID = 65535;
static NSString* const LEGACY_AUTO_ACTIVATE_ID_RETURNED = @"8675309";

@interface SDLProxyBase() <SDLConnectionDelegate, SDLProtocolListener>

//Flags
@property (nonatomic, getter=isAdvancedLifecycleManagementEnabled) BOOL advancedLifecycleManagementEnabled;
@property (nonatomic, getter=isAppInterfaceRegistered) NSNumber* appInterfaceRegistered;
@property (nonatomic, getter=isCycling) BOOL cycling;
@property (nonatomic, getter=isFirstTimeFull) BOOL firstTimeFull;
@property (nonatomic) BOOL haveReceivedFirstNonNoneHMILevel;
@property (nonatomic) BOOL haveReceivedFirstFocusLevel;
@property (nonatomic) BOOL haveReceivedFirstFocusLevelFull;
@property (nonatomic) BOOL proxyDisposed;
@property (nonatomic) BOOL resumeSuccess;
@property (nonatomic) BOOL navServiceResponseReceived;
@property (nonatomic) BOOL navServiceResponse;

@property (strong, nonatomic) NSNumber* preRegistered;
@property (strong, nonatomic) NSNumber* appResumeEnabled;
@property (strong, nonatomic, getter=isMediaApp) NSNumber* mediaApp;

@property (strong, nonatomic) NSString* lastHashID;
@property (strong, nonatomic) NSString* autoActivateIdDesired;

@property (strong, nonatomic) NSArray* vrSynonyms;
@property (strong, nonatomic) NSArray* appTypes;
@property (strong, nonatomic) NSArray* diagModes;

@property (nonatomic) Byte wiproVersion;
@property (nonatomic) int iFileCount;

@property (nonatomic) NSTimeInterval instanceTimeInterval;

@property (strong, nonatomic) SDLConnectionState* sdlConnectionState;
@property (strong, nonatomic) SDLInterfaceAvailability* sdlInterfaceAvailability;
@property (strong, nonatomic) SDLSession* sdlSession;
@property (strong, nonatomic) SDLBaseTransportConfig* transportConfig;
@property (strong, nonatomic) SDLProxyMessageDispatcher* outgoingProxyMessageDispatcher;
@property (strong, nonatomic) SDLProxyMessageDispatcher* incomingProxyMessageDispatcher;
@property (strong, nonatomic) SDLProxyMessageDispatcher* internalProxyMessageDispatcher;

@property (strong, nonatomic) NSArray* ttsName;
@property (strong, nonatomic) SDLSyncMsgVersion* sdlMsgVersionRequest;
@property (strong, nonatomic) SDLLanguage* sdlLanguageDesired;
@property (strong, nonatomic) SDLLanguage* hmiDisplayLanguageDesired;

@property (strong, nonatomic) SDLHMILevel* priorHmiLevel;
@property (strong, nonatomic) SDLAudioStreamingState* priorAudioStreamingState;

@property (weak, nonatomic) NSObject<SDLProxyListener>* delegate;//TODO:Create a ProxyListenerBase? Or just use optional methods from the protocol

@property (strong, nonatomic) NSMutableArray* buttonCapabilities;
@property (strong, nonatomic) NSMutableArray* softButtonCapabilities;
@property (strong, nonatomic) NSMutableArray* hmiZoneCapabilities;
@property (strong, nonatomic) NSMutableArray* speechCapabilities;
@property (strong, nonatomic) NSMutableArray* prerecordedSpeech;
@property (strong, nonatomic) NSMutableArray* vrCapabilities;
@property (strong, nonatomic) NSMutableArray* supportedDiagModes;
@property (strong, nonatomic) NSString* proxyVersionInfo;
@property (strong, nonatomic) SDLPresetBankCapabilities* presetBankCapabilities;
@property (strong, nonatomic) SDLDisplayCapabilities* displayCapabilities;
@property (strong, nonatomic) SDLLanguage* sdlLanguage;
@property (strong, nonatomic) SDLLanguage* hmiDisplayLanguage;
@property (strong, nonatomic) SDLSyncMsgVersion* sdlSyncMsgVersion;
@property (strong, nonatomic) SDLVehicleType* vehicleType;

@end

@implementation SDLProxyBase

-(instancetype)initWithProxyDelegate:(NSObject<SDLProxyListener>*)delegate
   enableAdvancedLifecycleManagement:(BOOL)enableAdvancedLifecycleManagement
                             appName:(NSString *)appName
                          isMediaApp:(NSNumber *)isMediaApp
                               appID:(NSString *)appID
                             options:(SDLProxyALMOptions *)options{
    self = [super init];
    if (self) {
        
        _instanceTimeInterval = [[NSDate date] timeIntervalSince1970];
        
        NSError* error;
        [self performBaseCommonProxyDelegate:delegate
           enableAdvancedLifecycleManagement:enableAdvancedLifecycleManagement
                                     appName:appName
                                  isMediaApp:isMediaApp
                                       appID:appID
                                     options:options
                                       error:&error];
        if (error) {
            //TODO: Log error
            return nil;
        }
    }
    return self;
}

-(void)performBaseCommonProxyDelegate:(NSObject<SDLProxyListener>*)delegate
    enableAdvancedLifecycleManagement:(BOOL)enableAdvancedLifecycleManagement
                              appName:(NSString *)appName
                           isMediaApp:(NSNumber *)isMediaApp
                                appID:(NSString *)appID
                              options:(SDLProxyALMOptions *)options
                                error:(NSError**)error{
    
    self.wiproVersion = PROX_PROT_VER_ONE;
    _advancedLifecycleManagementEnabled = enableAdvancedLifecycleManagement;
    _applicationName = appName;
    _mediaApp = isMediaApp;
    _applicationID = appID;
    
    NSNumber* preRegistered = options.preRegistered;
    
    if (preRegistered && [preRegistered boolValue]) {
        _appInterfaceRegistered = preRegistered;
        _preRegistered = preRegistered;
    }
    
    NSNumber* appResumeEnabled = options.appResumeEnabled;
    
    if (appResumeEnabled && [appResumeEnabled boolValue]) {
        _appResumeEnabled = @(YES);
        _lastHashID = options.hashID;
    }
    
    _ttsName = options.ttsName;
    _ngnMediaScreenAppName = options.ngnMediaScreenAppName;
    _sdlMsgVersionRequest = options.syncMsgVersion;
    _vrSynonyms = options.vrSynonyms;
    //TODO: Is this ok to default to EN_US?
    _sdlLanguageDesired = (options.languageDesired) ? options.languageDesired : [SDLLanguage EN_US];
    _hmiDisplayLanguageDesired = (options.hmiDisplayLanguageDesired) ? options.hmiDisplayLanguageDesired : [SDLLanguage EN_US];
    _appTypes = options.appTypes;
    _autoActivateIdDesired = options.autoActivateID;
    _transportConfig = options.transportConfig ? options.transportConfig : [SDLBaseTransportConfig new];
    
    if (!delegate) {
        *error = [NSError new];//TODO: Set this error
        return;
    }
    if (_advancedLifecycleManagementEnabled) {
        if (!self.isMediaApp) {
            *error = [NSError new];//TODO: Set this error
        }
    }
    
    _delegate = delegate;
    
    if (self.internalProxyMessageDispatcher) {
        [self.internalProxyMessageDispatcher dispose];
        self.internalProxyMessageDispatcher = nil;
    }
    
    __weak SDLProxyBase* weakSelf = self;
    
    self.internalProxyMessageDispatcher = [[SDLProxyMessageDispatcher alloc] initWithQueueName:@"INTERNAL_MESSAGE_DISPATCHER" completionHandler:^(id dispatchedMessage, NSException* exception) {
        if (!error) {
            if ([dispatchedMessage isKindOfClass:[SDLInternalProxyMessage class]]) {
                [weakSelf dispatchInternalMessage:dispatchedMessage];
            }
        }
        else{
            [weakSelf handleErrorsFromInternalMessageDispatcher:nil exception:exception];
        }
    }];
    
    if (self.incomingProxyMessageDispatcher) {
        [self.incomingProxyMessageDispatcher dispose];
        self.incomingProxyMessageDispatcher = nil;
    }
    self.incomingProxyMessageDispatcher = [[SDLProxyMessageDispatcher alloc] initWithQueueName:@"INCOMING_MESSAGE_DISPATCHER" completionHandler:^(SDLInternalProxyMessage *dispatchedMessage, NSException* exception) {
        if (!error) {
            if ([dispatchedMessage isKindOfClass:[SDLProtocolMessage class]]) {
                [weakSelf dispatchInternalMessage:dispatchedMessage];
            }
        }
        else{
            [weakSelf handleErrorsFromInternalMessageDispatcher:nil exception:exception];
        }
    }];
    
    if (self.outgoingProxyMessageDispatcher) {
        [self.outgoingProxyMessageDispatcher dispose];
        self.outgoingProxyMessageDispatcher = nil;
    }
    self.outgoingProxyMessageDispatcher = [[SDLProxyMessageDispatcher alloc] initWithQueueName:@"INCOMING_MESSAGE_DISPATCHER" completionHandler:^(SDLInternalProxyMessage *dispatchedMessage, NSException* exception) {
        if (!error) {
            if ([dispatchedMessage isKindOfClass:[SDLProtocolMessage class]]) {
                [weakSelf dispatchInternalMessage:dispatchedMessage];
            }
        }
        else{
            [weakSelf handleErrorsFromInternalMessageDispatcher:nil exception:exception];
        }
    }];
    
    [self initializeProxy];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
}

-(void)initializeProxy{
    _haveReceivedFirstNonNoneHMILevel = NO;
    _haveReceivedFirstFocusLevel = NO;
    _haveReceivedFirstFocusLevelFull = NO;

    _appInterfaceRegistered = _preRegistered;
    
    _sdlInterfaceAvailability = [SDLInterfaceAvailability UNAVAILABLE];
    
    self.sdlSession = [SDLSession createSessionWithWiProVersion:self.wiproVersion interfaceBroker:self transportConfig:self.transportConfig];
    
    [self.sdlSession startSession];
    [self sendTransportNotification];
}

-(void)sendTransportNotification{
    
    if (self.sdlSession == nil || self.transportConfig == nil) {
        return;
    }
    
    NSString* sTransComment = [self.sdlSession notificationComment];
    
    if (sTransComment == nil || [sTransComment isEqualToString:@""]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SDLProxyBaseTransportNotification"
                                                        object:@{@"FUNCTION_NAME": @"initializeProxy",
                                                                 @"COMMENT1": sTransComment}];
}

+(void)enableSiphonDebug{
    [SDLSiphonServer enableSiphonDebug];
}

+(void)disableSiphonDebug{
    [SDLSiphonServer disableSiphonDebug];
}

+(void)enableDebugTool{
    [SDLDebugTool enableDebugToLogFile];
}

+(void)disableDebugTool{
    [SDLDebugTool disableDebugToLogFile];
}

-(void)navServiceStarted{
    _navServiceResponseReceived = YES;
    _navServiceResponse = YES;
}

-(void)addCommandWithCommandID:(NSNumber *)commandID menuText:(NSString *)menuText parentID:(NSNumber *)parentID position:(NSNumber *)position vrCommands:(NSArray *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType *)imageType correlationID:(NSNumber *)correlationID{
    //TODO:Implement
}

-(void)addSubMenuWithMenuID:(NSNumber *)menuID menuName:(NSString *)menuName correlationID:(NSNumber *)correlationID{
    //TODO:Implement
}

-(void)registerAppInterfacePrivate:(SDLSyncMsgVersion*)sdlMsgVersion appName:(NSString*)appName ttsName:(NSArray*)ttsName ngnMediaScreenAppName:(NSString*)ngnMediaScreenAppName vrSynonyms:(NSArray*)vrSynonyms isMediaApp:(NSNumber*)isMediaApp languageDesired:(SDLLanguage*)languageDesired hmiDisplayLanguageDesired:(SDLLanguage*)hmiDisplayLanguageDesired appHMITypes:(NSArray*)appHMITypes appID:(NSString*)appID autoActivateID:(NSString*)autoActivateID correlationID:(NSNumber*)correlationID{

    SDLRegisterAppInterface* msg = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:appName ttsName:[ttsName mutableCopy] vrSynonyms:[vrSynonyms mutableCopy] isMediaApp:isMediaApp languageDesired:languageDesired hmiDisplayLanguageDesired:hmiDisplayLanguageDesired appID:appID];
    msg.correlationID = @(REGISTER_APP_INTERFACE_CORRELATION_ID);
    if (_appResumeEnabled) {
        if (_lastHashID) {
            msg.hashID = _lastHashID;
        }
    }
    [self sendRPCRequestPrivate:msg];
}

//TODO:SDLDebugTool isDebugEnabled does not exist yet
//+(BOOL)isDebugEnabled{
//    return [SDLDebugTool isDebugEnabled];
//}

-(void)cycleProxy:(SDLDisconnectReason)reason{//TODO:Add with SDLDisconnectedReason
    if (self.isCycling){ return; }
    
    _cycling = YES;
    [self cleanProxy];
    [self initializeProxy];
    //TODO:Add error
    [self notifyProxyClosedWithInfo:@"Proxy cycled" error:nil reason:reason];
}

-(void)cleanProxy{//TODO: Add disconnectedReason
    if (self.isAdvancedLifecycleManagementEnabled) {
        self.sdlConnectionState = [SDLConnectionState DISCONNECTED];
        self.firstTimeFull = YES;
        
        BOOL waitForInterfaceUnregistered = NO;
        if (self.sdlSession && self.sdlSession.isConnected && self.isAppInterfaceRegistered) {
            waitForInterfaceUnregistered = YES;
            [self unregisterAppInterfacePrivate:@(UNREGISTER_APP_INTERFACE_CORRELATION_ID)];
        }
        
        if (waitForInterfaceUnregistered) {
            //TODO:What is appropriate here?
        }
    }
    if (self.sdlSession) {
        [self.sdlSession close];
    }
}

-(void)dispose{
    if (self.proxyDisposed) {
        return;
    }
    
    _proxyDisposed = YES;
    
    [self cleanProxy];
    
    if (self.internalProxyMessageDispatcher) {
        [self.internalProxyMessageDispatcher dispose];
        self.internalProxyMessageDispatcher = nil;
    }
    
    if (self.incomingProxyMessageDispatcher) {
        [self.incomingProxyMessageDispatcher dispose];
        self.incomingProxyMessageDispatcher = nil;
    }
    
    if (self.outgoingProxyMessageDispatcher) {
        [self.outgoingProxyMessageDispatcher dispose];
        self.outgoingProxyMessageDispatcher = nil;
    }
}

-(void)dispatchIncomingMessage:(SDLProtocolMessage*)message{
    
    if (message.sessionType == SDLServiceType_RPC) {
        
        if (self.wiproVersion == 1) {
            if (message.version > 1) {
                self.wiproVersion = message.version;
            }
        }
        
        NSMutableDictionary* rpcDictionary = [NSMutableDictionary new];
        if (self.wiproVersion > 1) {
            
            NSMutableDictionary* rpcDictionaryTemp = [NSMutableDictionary new];
            rpcDictionaryTemp[NAMES_correlationID] = message.correlationID;
            if ([message size] > 1) {//TODO:Is this the same as Android "jsonSize" implementation?
                NSDictionary* mDictionary = [[SDLJsonDecoder instance] decode:message.payload];
                rpcDictionaryTemp[NAMES_parameters] = mDictionary;
            }
            NSString* functionName = [[SDLFunctionID new] getFunctionName:[message.functionID intValue]];
            if (functionName) {
                //TODO:Is this the correct key?
                rpcDictionaryTemp[NAMES_name] = functionName;
            }
            else{
                
                [SDLDebugTool logInfo:[NSString stringWithFormat:@"Dispatch Incoming Message - function name is null unknown RPC. FunctionID: %@", message.functionID]];
                return;
            }
            
            if (message.rpcType == 0x00) {
               rpcDictionary[NAMES_request] = rpcDictionaryTemp;
            }
            else if (message.rpcType == 0x01){
                rpcDictionary[NAMES_response] = rpcDictionaryTemp;
            }
            else if (message.rpcType == 0x02){
                rpcDictionary[NAMES_notification] = rpcDictionaryTemp;
            }
            
            if (message.bulkData) {
                rpcDictionary[NAMES_bulkData] = message.bulkData;
            }
        }
        else{
            rpcDictionary = [[message rpcDictionary] mutableCopy];
        }
        
        [self handleRPCMessage:rpcDictionary];
    }
    else{
        
    }
}

-(void)writeObject:(NSObject*)object toFileName:(NSString*)filename{
    
    //TODO: This method needs testing to ensure pathing on both simulator & physical device.
    NSString* sFileName = [NSString stringWithFormat:@"%@_%@.txt", filename, @(self.iFileCount)];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* appSupportDir = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL* outDirPath;
    if ([appSupportDir count] > 0) {
        outDirPath = [[appSupportDir firstObject] URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
        
        NSError* error;
        if (![fileManager createDirectoryAtURL:outDirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            //TODO: Log error
            return;
        }
        NSURL* outURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [outDirPath path], sFileName]];
        NSString* objectDescription = [object description];
        
        if (![fileManager createFileAtPath:[outURL path] contents:[objectDescription dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
            //TODO: Log error
            return;
        }
        //This should be delegate callback "didWriteObject", but for now let's follow the Android code base
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SDLProxyBaseDidWriteObjectToFileNotification"
                                                            object:@{@"FUNCTION_NAME": @"writeToFile",
                                                                     @"SHOW_ON_UI": @(NO)}];
    }
}

-(void)logHeaderWithType:(NSString*)type string:(NSString*)myString functionName:(NSString*)functionName{
    //TODO: This should not use notifications to blast out to everyone, but let's do what SDL for Android did for now.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SDLProxyBaseLogHeaderNotification"
                                                        object:@{@"FUNCTION_NAME": functionName,
                                                                 @"COMMENT1": [NSString stringWithFormat:@"%@\r\n", type],
                                                                 @"DATA": myString}];
}

-(NSURLSessionDataTask*)urlSessionDataTaskWithHeader:(NSDictionary*)header url:(NSURL*)url timeout:(NSTimeInterval)timeout contentLength:(NSUInteger)contentLength{
    
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forKey:@"Content-Type"];
    [request setValue:@(contentLength) forKey:@"Content-Length"];
    
    NSURLSessionDataTask* postTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    return postTask;
    //TODO: It might be best to just implement this in sendOnSystemRequestToUrl
}

-(void)sendOnSystemRequestToUrl:(SDLOnSystemRequest*)request{
    
    NSString* urlString;
    BOOL bLegacy = NO;
    
    if (![self.policiesURLString isEqualToString:@""]) {
        urlString = self.policiesURLString;
    }
    else{
        urlString = request.url;
    }
    
    NSNumber* iTimeout = request.timeout;
    
    if (!iTimeout) {
        iTimeout = @(2000);
    }
    
    //Headers myHeader = reaquest.header //TODO: Not yet implemented
    NSString* functionName = @"SYSTEM_REQUEST";
    
    NSString* bodyString = request.body; //TODO: Not yet implemented
    
    NSDictionary* jsonObjectToSendToServer;
    NSString* validJson;
    
    if (!bodyString) {
    NSArray* jsonArrayOfSdlPPackets = request.legacyData;
    jsonObjectToSendToServer = @{@"data" : jsonArrayOfSdlPPackets};
    bLegacy = YES;
    functionName = @"SYSTEM_REQUEST_LEGACY";
    validJson = [[jsonObjectToSendToServer description] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    else{
    validJson = [bodyString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    
    [self writeObject:validJson toFileName:@"requestToCloud"];
    //TODO: LogHeader
    
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[iTimeout doubleValue]];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [validJson dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setValue:@"application/json" forKey:@"Content-Type"];
    [urlRequest setValue:@([validJson dataUsingEncoding:NSUTF8StringEncoding].length) forKey:@"Content-Length"];
    
    __block NSTimeInterval beforeTime = [[NSDate date] timeIntervalSince1970];

    NSURLSessionDataTask* postTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSString* responseMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSTimeInterval afterTime = [[NSDate date] timeIntervalSince1970];
        
        NSTimeInterval roundtripTime = afterTime - beforeTime;
        
        NSInteger responseCode = ((NSHTTPURLResponse*)response).statusCode;
        
        if (responseCode != 200) {
            return;
        }
        [self writeObject:[response description] toFileName:@"responseFromCloud"];
        //TODO:LogHeader
        
        NSMutableArray* cloudDataReceived = [NSMutableArray new];
        
        NSError* jsonError;
        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (jsonError) {
            //TODO: Log
            return;
        }
        
        if ([[jsonResponse objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArray = jsonResponse[@"data"];
            for (id obj in jsonArray) {
                if ([obj isKindOfClass:[NSString class]]) {
                    [cloudDataReceived addObject:obj];
                }
            }
        }
        else if ([[jsonResponse objectForKey:@"data"] isKindOfClass:[NSString class]]){
            [cloudDataReceived addObject:jsonResponse[@"data"]];
        }
        else{
            [SDLDebugTool logInfo:@"sendOnSystemRequestToUrl: Data in JSON Object neither an array nor a string."];
            return;
        }
        
        NSString* responseString = [cloudDataReceived description];
        
        if ([responseString length] > 512) {
            responseString = [responseString substringToIndex:511];
        }
        
        SDLSystemRequest* systemRequest;
        
        if (bLegacy) {
//            systemRequest = [SDLRPCRequestFactory buildSystemRequestLegacyWithCloudDataStringArray:cloudDataReceived correlationID:@(POLICIES_CORRELATION_ID)];//TODO:Not yet implemented
        }
        else{
//            systemRequest = [SDLRPCRequestFactory buildSystemRequestLegacyWithCloudDataStringArray:[request description] correlationID:@(POLICIES_CORRELATION_ID)];//TODO:Not yet implemented
        }
        
        if ([self isConnected]) {
            [self sendRPCRequestPrivate:systemRequest];
            //TODO: Add log
        }
        
        if (self.iFileCount < 10) {
            self.iFileCount++;
        }
        else{
            self.iFileCount = 0;
        }
    }];
    [postTask resume];
}

-(NSMutableDictionary*)serializeJSON:(SDLRPCMessage*)msg{
    //TODO: Should this be returning a NSString or NSMutableDictionary?
    return [msg serializeAsDictionary:self.wiproVersion];
}

-(void)sendRPCRequest:(SDLRPCRequest*)request{
    
    if (self.proxyDisposed) {
        //TODO: Notify proxy with NSError?
        return;
    }
    if (!request) {
        //TODO:Return NSError?
        //Return BOOL & NSError as parameter? sendRPCRequest:error
    }
    if (!self.sdlSession || ![self.sdlSession isConnected]) {
        //TODO:Return NSError?
        return;
    }
    if ([self isCorrelationIDProtected:request.correlationID]) {
        //TODO:logProxyEvent
        //TODO:Return Error
    }
    if (!self.isAppInterfaceRegistered && ![request.getFunctionName isEqualToString:NAMES_RegisterAppInterface]) {
        //TODO:logProxyEvent
        //TODO:Return Error
    }
    if (_advancedLifecycleManagementEnabled) {
        if ([request.getFunctionName isEqualToString:NAMES_RegisterAppInterface]
            || [request.getFunctionName isEqualToString:NAMES_UnregisterAppInterface]) {
            //TODO:logProxyEvent
            //TODO:Return Error
        }
    }
    
    [self sendRPCRequestPrivate:request];
}

- (void)invokeMethodOnDelegates:(SEL)aSelector withObject:(id)object {
 
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([self.delegate conformsToProtocol:@protocol(SDLProxyListener)]
            && [self.delegate respondsToSelector:aSelector]) {
            
            //[self performSelector:aSelector withObject:object]; Should not be used with ARC.
            //Alternative is to explicitly call methods.
            
            //The following protects agains a possible leak when using "performSelector" with ARC.
            //Reference:https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html#//apple_ref/c/tag/IMP
            IMP delegateIMP = [self.delegate methodForSelector:aSelector];
            void (*delegateMethod)(id, SEL, id) = (void *)delegateIMP;
            delegateMethod(self.delegate, aSelector, object);
        }
    }];
}

-(void)dispatchInternalMessage:(SDLInternalProxyMessage*)message{
    if ([message.functionName isEqualToString:SDLInternalProxyMessageOnProxyError]) {
        SDLOnError* msg = (SDLOnError*)message;
        //TODO: Passing NSException to meeting API, but recommend transition to NSError to meet iOS practices.
        
        [self invokeMethodOnDelegates:@selector(onError:) withObject:[NSException exceptionWithName:msg.error.domain reason:[msg.error localizedFailureReason] userInfo:msg.error.userInfo]];
        
        /**************Start Legacy Specific Call-backs************/
    } else if ([message.functionName isEqualToString:SDLInternalProxyMessageOnProxyOpened]) {
    
        [self invokeMethodOnDelegates:@selector(onProxyOpened) withObject:nil];

    } else if ([message.functionName isEqualToString:SDLInternalProxyMessageOnProxyClosed]) {
        
        [self invokeMethodOnDelegates:@selector(onProxyClosed) withObject:nil];

        /****************End Legacy Specific Call-backs************/
    } else {
        // Diagnostics
        //TODO: Add logging
    }
}

-(void)sendRPCRequestPrivate:(SDLRPCRequest *)request{
    
    [self dispatchOutgoingMessage:request];

    //TODO: The following is needed if we pass a ProtocolMessage istead. Although, SDLRPCRequest already seems cleaner at first glance.
    /*
    //TODO: Trace logRPCEvent
    
    NSData *msgBytes = [[SDLJsonEncoder instance] encodeDictionary:[request serializeAsDictionary:self.wiproVersion]];
    
    SDLProtocolMessage* pm = [SDLProtocolMessage new];
    pm.payload = msgBytes;
    if (self.sdlSession) {
        pm.sessionID = self.sdlSession.sessionID;
    }
    pm.messageType = SDLMessageType_RPC;
    pm.sessionType = SDLServiceType_RPC;
    pm.functionID = [[SDLFunctionID new] getFunctionID:request.getFunctionName];
    if (!request.correlationID) {
        //TODO: Log error
        return;
    }
    pm.correlationID = request.correlationID;
    if (request.bulkData) {
        pm.bulkData = request.bulkData;
        [self dispatchOutgoingMessage:request];
    }
    
    
    */
    //TODO: This is bypassing a message queue;
    
//    [self.outgoingProxyMessageDispatcher queueMessage:pm];
}

-(void)handleRPCMessage:(NSDictionary*)message{
    
    SDLRPCMessage* rpcMessage = [[SDLRPCMessage alloc] initWithDictionary:[message mutableCopy]];
    NSString* functionName = [rpcMessage getFunctionName];
    NSString* messageType = rpcMessage.messageType;
    
    SDLRPCResponse* response = [[SDLRPCResponse alloc] initWithDictionary:[message mutableCopy]];
    
    if ([messageType isEqualToString:NAMES_response]) {
        if ([self isCorrelationIDProtected:response.correlationID]) {
            if ([response.correlationID intValue] == REGISTER_APP_INTERFACE_CORRELATION_ID
                && self.advancedLifecycleManagementEnabled
                && [functionName isEqualToString:NAMES_RegisterAppInterface]) {
                
                SDLRegisterAppInterfaceResponse* msg = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:[message mutableCopy]];
                if ([msg.success boolValue]) {
                    self.appInterfaceRegistered = @(YES);
                }
                
                self.autoActivateIdDesired = LEGACY_AUTO_ACTIVATE_ID_RETURNED; //Placeholder for legacy support
                self.buttonCapabilities = msg.buttonCapabilities;
                self.displayCapabilities = msg.displayCapabilities;
                self.softButtonCapabilities = msg.softButtonCapabilities;
                self.presetBankCapabilities = msg.presetBankCapabilities;
                self.hmiZoneCapabilities = msg.hmiZoneCapabilities;
                self.speechCapabilities = msg.speechCapabilities;
                self.prerecordedSpeech = msg.prerecordedSpeech;
                self.sdlLanguage = msg.language;
                self.hmiDisplayLanguage = msg.hmiDisplayLanguage;
                self.sdlSyncMsgVersion = msg.syncMsgVersion; //TODO: Shouldn't this Sync reference be refactored out?
                self.vrCapabilities = msg.vrCapabilities;
                self.vehicleType = msg.vehicleType;
                self.proxyVersionInfo = [msg proxyVersionInfo];
                
                if ([self.appResumeEnabled boolValue]) {
                    if (msg.resultCode == [SDLResult RESUME_FAILED]
                        || msg.resultCode == [SDLResult SUCCESS]) {
                        self.resumeSuccess = NO;
                        self.lastHashID = nil;
                    }
                    else if (([self.sdlSyncMsgVersion.majorVersion intValue] > 2)
                             && self.lastHashID && msg.resultCode == [SDLResult SUCCESS]){
                        self.resumeSuccess = YES;
                    }
                }
                self.diagModes = msg.supportedDiagModes;
                
                NSString* versionInfo = [NSString stringWithFormat:@"SDL Proxy Version: %@", self.proxyVersionInfo];
                
                //TODO: Enable after isDebugEnabled is implemented
//                if (![self isDebugEnabled]) {
//                    [self enableDebugTool];
//                    [SDLDebugTool logInfo:versionInfo];
//                    [self disableDebugTool];
//                }
//                else{
//                    [SDLDebugTool logInfo:versionInfo];
//                }
                self.sdlConnectionState = [SDLConnectionState CONNECTED];
                
                if (![msg.success boolValue]) {
                    [self notifyProxyClosedWithInfo:@"Unable to register app interface. Review values passed to the SdlProxy constructor. RegisterAppInterface result code: " error:nil reason:SDLDisconnectReasonRegistrationError];
                }
                [self invokeMethodOnDelegates:@selector(onRegisterAppInterfaceResponse:) withObject:msg];
            }
            else if ([response.correlationID intValue] == POLICIES_CORRELATION_ID
                     && [functionName isEqualToString:NAMES_OnEncodedSyncPData]){
                NSLog(@"POLICIES_CORRELATION_ID SystemRequest Notification (Legacy)");
                
                SDLOnSystemRequest* msg = [[SDLOnSystemRequest alloc] initWithDictionary:[message mutableCopy]];
                if (msg.url) {
                    [self sendOnSystemRequestToUrl:msg];//TOOD:Very async
                }
            }
            else if ([response.correlationID intValue] == POLICIES_CORRELATION_ID
                     && [functionName isEqualToString:NAMES_EncodedSyncPData]){
                NSLog(@"POLICIES_CORRELATION_ID SystemRequest Notification (Legacy)");
                
                SDLSystemRequestResponse* msg = [[SDLSystemRequestResponse alloc] initWithDictionary:[message mutableCopy]];
                
            }
            else if ([functionName isEqualToString:NAMES_UnregisterAppInterface]){
                self.appInterfaceRegistered = @(NO);
                SDLUnregisterAppInterfaceResponse* msg = [[SDLUnregisterAppInterfaceResponse alloc] initWithDictionary:[message mutableCopy]];
            }
            return;
        }
        
        if ([functionName isEqualToString:NAMES_RegisterAppInterface]) {
            
            SDLRegisterAppInterfaceResponse* msg = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:[message mutableCopy]];
            if ([msg.success boolValue]) {
                self.appInterfaceRegistered = @(YES);
            }
            self.autoActivateIdDesired = LEGACY_AUTO_ACTIVATE_ID_RETURNED; //Placeholder for legacy support
            self.buttonCapabilities = msg.buttonCapabilities;
            self.displayCapabilities = msg.displayCapabilities;
            self.softButtonCapabilities = msg.softButtonCapabilities;
            self.presetBankCapabilities = msg.presetBankCapabilities;
            self.hmiZoneCapabilities = msg.hmiZoneCapabilities;
            self.speechCapabilities = msg.speechCapabilities;
            self.prerecordedSpeech = msg.prerecordedSpeech;
            self.sdlLanguage = msg.language;
            self.hmiDisplayLanguage = msg.hmiDisplayLanguage;
            self.sdlSyncMsgVersion = msg.syncMsgVersion; //TODO: Shouldn't this Sync reference be refactored out?
            self.vrCapabilities = msg.vrCapabilities;
            self.vehicleType = msg.vehicleType;
            self.proxyVersionInfo = msg.proxyVersionInfo;
            
            if ([self.appResumeEnabled boolValue]) {
                if (msg.resultCode == [SDLResult RESUME_FAILED]
                    || msg.resultCode != [SDLResult SUCCESS]) {
                    self.resumeSuccess = NO;
                    self.lastHashID = nil;
                }
                else if ([self.sdlSyncMsgVersion.majorVersion intValue] > 2 && self.lastHashID
                         && msg.resultCode == [SDLResult SUCCESS]){
                    self.resumeSuccess = YES;
                }
            }
            
            self.diagModes = msg.supportedDiagModes;
            
//            if (![self isDebugEnabled]) {//TODO: Enable after isDebugEnabled is implemented
//                [self enableDebugTool];
//                [SDLDebugTool logInfo:[NSString stringWithFormat:@"SDL Proxy Version: %@", self.proxyVersionInfo]];
//                [self disableDebugTool];
//            }
//            else{
//               [SDLDebugTool logInfo:[NSString stringWithFormat:@"SDL Proxy Version: %@", self.proxyVersionInfo]];
//            }
            
            if (self.advancedLifecycleManagementEnabled) {
                self.sdlConnectionState = [SDLConnectionState CONNECTED];
                
                if (![msg.success boolValue]) {
                    [self notifyProxyClosedWithInfo:@"Unable to register app interface. Review values passed to the SdlProxy constructor. RegisterAppInterface result code: " error:nil reason:SDLDisconnectReasonRegistrationError];
                }
            }
            else{
                if (!_advancedLifecycleManagementEnabled) {
                    [self invokeMethodOnDelegates:@selector(onRegisterAppInterfaceResponse:) withObject:msg];
                }
            }
        }
        else if ([functionName isEqualToString:NAMES_Speak]){
            SDLSpeakResponse* msg = [[SDLSpeakResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSpeakResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_Alert]){
            SDLAlertResponse* msg = [[SDLAlertResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onAlertResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_Show]){
            SDLShowResponse* msg = [[SDLShowResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onShowResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_AddCommand]){
            SDLAddCommandResponse* msg = [[SDLAddCommandResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onAddCommandResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_DeleteCommand]){
            SDLDeleteCommandResponse* msg = [[SDLDeleteCommandResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onDeleteCommandResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_AddSubMenu]){
            SDLAddSubMenuResponse* msg = [[SDLAddSubMenuResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onAddSubMenuResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_DeleteSubMenu]){
            SDLDeleteSubMenuResponse* msg = [[SDLDeleteSubMenuResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onDeleteSubMenuResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SubscribeButton]){
            SDLSubscribeButtonResponse* msg = [[SDLSubscribeButtonResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSubscribeButtonResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_UnsubscribeButton]){
            SDLUnsubscribeButtonResponse* msg = [[SDLUnsubscribeButtonResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onUnsubscribeButtonResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SetMediaClockTimer]){
            SDLSetMediaClockTimerResponse* msg = [[SDLSetMediaClockTimerResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSetMediaClockTimerResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_EncodedSyncPData]){
            SDLEncodedSyncPDataResponse* msg = [[SDLEncodedSyncPDataResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onEncodedSyncPDataResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_CreateInteractionChoiceSet]){
            SDLCreateInteractionChoiceSetResponse* msg = [[SDLCreateInteractionChoiceSetResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onCreateInteractionChoiceSetResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_DeleteInteractionChoiceSet]){
            SDLDeleteInteractionChoiceSetResponse* msg = [[SDLDeleteInteractionChoiceSetResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onDeleteInteractionChoiceSetResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_PerformInteraction]){
            SDLPerformInteractionResponse* msg = [[SDLPerformInteractionResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onPerformInteractionResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SetGlobalProperties]){
            SDLSetGlobalPropertiesResponse* msg = [[SDLSetGlobalPropertiesResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSetGlobalPropertiesResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_ResetGlobalProperties]){
            SDLResetGlobalPropertiesResponse* msg = [[SDLResetGlobalPropertiesResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onResetGlobalPropertiesResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_UnregisterAppInterface]){
            
            self.appInterfaceRegistered = @(NO);
            SDLUnregisterAppInterfaceResponse* msg = [[SDLUnregisterAppInterfaceResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onUnregisterAppInterfaceResponse:) withObject:msg];
            [self notifyProxyClosedWithInfo:@"onUnregisterAppInterfaceResponse" error:nil reason:SDLDisconnectReasonAppInterfaceUnregistered];
        }
        else if ([functionName isEqualToString:NAMES_Slider]){
            SDLSliderResponse* msg = [[SDLSliderResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSliderResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_PutFile]){
            SDLPutFileResponse* msg = [[SDLPutFileResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onPutFileResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_DeleteFile]){
            SDLDeleteFileResponse* msg = [[SDLDeleteFileResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onDeleteFileResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_ListFiles]){
            SDLListFilesResponse* msg = [[SDLListFilesResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onListFilesResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SetAppIcon]){
            SDLSetAppIconResponse* msg = [[SDLSetAppIconResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSetAppIconResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_ScrollableMessage]){
            SDLScrollableMessageResponse* msg = [[SDLScrollableMessageResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onScrollableMessageResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_ChangeRegistration]){
            SDLChangeRegistrationResponse* msg = [[SDLChangeRegistrationResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onChangeRegistrationResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SetDisplayLayout]){
            SDLSetDisplayLayoutResponse* msg = [[SDLSetDisplayLayoutResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSetDisplayLayoutResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_PerformAudioPassThru]){
            SDLPerformAudioPassThruResponse* msg = [[SDLPerformAudioPassThruResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onPerformAudioPassThruResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_EndAudioPassThru]){
            SDLEndAudioPassThruResponse* msg = [[SDLEndAudioPassThruResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onEndAudioPassThruResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SubscribeVehicleData]){
            SDLSubscribeVehicleDataResponse* msg = [[SDLSubscribeVehicleDataResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSubscribeVehicleDataResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_UnsubscribeVehicleData]){
            SDLUnsubscribeVehicleDataResponse* msg = [[SDLUnsubscribeVehicleDataResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onUnsubscribeVehicleDataResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_GetVehicleData]){
            SDLGetVehicleDataResponse* msg = [[SDLGetVehicleDataResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onGetVehicleDataResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_ReadDID]){
            SDLReadDIDResponse* msg = [[SDLReadDIDResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onReadDIDResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_GetDTCs]){
            SDLGetDTCsResponse* msg = [[SDLGetDTCsResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onGetDTCsResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_DiagnosticMessage]){
            SDLDiagnosticMessageResponse* msg = [[SDLDiagnosticMessageResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onDiagnosticMessageResponse:) withObject:msg];
        }
        else if ([functionName isEqualToString:NAMES_SystemRequest]){
            SDLSystemRequestResponse* msg = [[SDLSystemRequestResponse alloc] initWithDictionary:[message mutableCopy]];
            [self invokeMethodOnDelegates:@selector(onSystemRequestResponse:) withObject:msg];
        }
        else{
            if (self.sdlSyncMsgVersion) {
                [SDLDebugTool logInfo:[NSString stringWithFormat:@"Unrecognized response Message: %@ SDL Message Version = %@", functionName, [self.sdlSyncMsgVersion description]]];
            }
        }
    }
    else if ([messageType isEqualToString:NAMES_notification]){
        if ([functionName isEqualToString:NAMES_OnHMIStatus]) {
            
            SDLOnHMIStatus* msg = [[SDLOnHMIStatus alloc] initWithDictionary:[message mutableCopy]];
            
            if (self.sdlSession) {
                self.sdlSession.lockScreenManager.hmiLevel = msg.hmiLevel;
            }
            msg.firstRun = self.firstTimeFull;
            if (msg.hmiLevel == [SDLHMILevel HMI_FULL]) {
                self.firstTimeFull = NO;
            }
            
            if (msg.hmiLevel != self.priorHmiLevel && msg.audioStreamingState != self.priorAudioStreamingState) {
                [self invokeMethodOnDelegates:@selector(onOnHMIStatus:) withObject:msg];
                //TODO:Not yet implemented
//                [self.onOnLockScreenNotification:self.sdlSession.lockScreenManager.lockScreenStatusNotification];
            }
        }
    }
    else if ([functionName isEqualToString:NAMES_OnCommand]){
        SDLOnCommand* msg = [[SDLOnCommand alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnCommand:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnDriverDistraction]){
        SDLOnDriverDistraction* msg = [[SDLOnDriverDistraction alloc] initWithDictionary:[message mutableCopy]];
        if (self.sdlSession) {
            SDLDriverDistractionState* ddState = msg.state;
            BOOL value = NO;//TODO:Verify this comparison
            if (ddState == [SDLDriverDistractionState DD_ON]) {
                value = YES;
            }
            self.sdlSession.lockScreenManager.bDriverDistractionStatus = value;
        }
        [self invokeMethodOnDelegates:@selector(onOnDriverDistraction:) withObject:msg];
        [self invokeMethodOnDelegates:@selector(onOnLockScreenNotification:) withObject:self.sdlSession.lockScreenManager.lockScreenStatusNotification];
        //TODO:Not yet implemented
        //                [self.onOnLockScreenNotification:self.sdlSession.lockScreenManager.lockScreenStatusNotification];
    }
    else if ([functionName isEqualToString:NAMES_OnEncodedSyncPData]){
        //FIXME:???Shouldn't this code block be OnEncodedSyncPData?
        SDLOnSystemRequest* msg = [[SDLOnSystemRequest alloc] initWithDictionary:[message mutableCopy]];
        
        if (!msg.url) {
            [self invokeMethodOnDelegates:@selector(onOnSystemRequest:) withObject:msg];
        }
        else{
            NSLog(@"send to url");
            if (msg.url) {
                [self sendOnSystemRequestToUrl:msg];
            }
        }
    }
    else if ([functionName isEqualToString:NAMES_OnPermissionsChange]){
        SDLOnPermissionsChange* msg = [[SDLOnPermissionsChange alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnPermissionsChange:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnTBTClientState]){
        SDLOnTBTClientState* msg = [[SDLOnTBTClientState alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnTBTClientState:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnButtonPress]){
        SDLOnButtonPress* msg = [[SDLOnButtonPress alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnButtonPress:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnButtonEvent]){
        SDLOnButtonEvent* msg = [[SDLOnButtonEvent alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnButtonEvent:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnLanguageChange]){
        SDLOnLanguageChange* msg = [[SDLOnLanguageChange alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnLanguageChange:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnHashChange]){
        SDLOnHashChange* msg = [[SDLOnHashChange alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnHashChange:) withObject:msg];
        if ([self.appResumeEnabled boolValue]) {
            self.lastHashID = msg.hashID;
        }
    }
    else if ([functionName isEqualToString:NAMES_OnSystemRequest]){
        SDLOnSystemRequest* msg = [[SDLOnSystemRequest alloc] initWithDictionary:[message mutableCopy]];
        
        if (msg.url && msg.requestType == [SDLRequestType PROPRIETARY] && msg.fileType == [SDLFileType JSON]) {
            [self sendOnSystemRequestToUrl:msg];
        }
        [self invokeMethodOnDelegates:@selector(onOnSystemRequest:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnAudioPassThru]){
        SDLOnAudioPassThru* msg = [[SDLOnAudioPassThru alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnAudioPassThru:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnVehicleData]){
        SDLOnVehicleData* msg = [[SDLOnVehicleData alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnVehicleData:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnAppInterfaceUnregistered]){
        
        self.appInterfaceRegistered = @(NO);
        
        SDLOnAppInterfaceUnregistered* msg = [[SDLOnAppInterfaceUnregistered alloc] initWithDictionary:[message mutableCopy]];
        
        if (self.advancedLifecycleManagementEnabled) {
            [self cycleProxy:[msg.reason disconnectReasonFromUnregisteredReason:msg.reason]];
        }
        else{
            [self invokeMethodOnDelegates:@selector(onOnAppInterfaceUnregistered:) withObject:msg];
            [self notifyProxyClosedWithInfo:@"OnAppInterfaceUnregistered" error:nil reason:SDLDisconnectReasonAppInterfaceUnregistered];
        }
    }
    else if ([functionName isEqualToString:NAMES_OnKeyboardInput]){
        SDLOnKeyboardInput* msg = [[SDLOnKeyboardInput alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnKeyboardInput:) withObject:msg];
    }
    else if ([functionName isEqualToString:NAMES_OnTouchEvent]){
        SDLOnKeyboardInput* msg = [[SDLOnKeyboardInput alloc] initWithDictionary:[message mutableCopy]];
        [self invokeMethodOnDelegates:@selector(onOnTouchEvent:) withObject:msg];
    }
    else{
        if (self.sdlSyncMsgVersion) {
            [SDLDebugTool logInfo:[NSString stringWithFormat:@"Unrecognized response Message: %@ connected SDL using message version: %@.%@", functionName, self.sdlSyncMsgVersion.majorVersion, self.sdlSyncMsgVersion.minorVersion]];
        }
        else{
            [SDLDebugTool logInfo:[NSString stringWithFormat:@"Unrecognized response Message: %@", functionName]];
        }
    }
}

-(void)notifyProxyClosedWithInfo:(NSString*)info error:(NSError*)error reason:(SDLDisconnectReason)reason{//TODO:Add parameters
    SDLOnProxyClosed* msg = [[SDLOnProxyClosed alloc] initWithInfo:info error:error reason:reason];
    [self queueInternalMessage:msg];
}

-(void)startRPCProtocolSession:(Byte)sessionID correlationID:(NSString*)correlationID{
    if (_advancedLifecycleManagementEnabled) {
        
        [self registerAppInterfacePrivate:_sdlMsgVersionRequest appName:_applicationName ttsName:_ttsName ngnMediaScreenAppName:_ngnMediaScreenAppName vrSynonyms:_vrSynonyms isMediaApp:_mediaApp languageDesired:_sdlLanguageDesired hmiDisplayLanguageDesired:_hmiDisplayLanguageDesired appHMITypes:_appTypes appID:_applicationID autoActivateID:_autoActivateIdDesired correlationID:@(REGISTER_APP_INTERFACE_CORRELATION_ID)];
    } else {
        SDLInternalProxyMessage* message = [[SDLInternalProxyMessage alloc] initWithFunctionName:SDLInternalProxyMessageOnProxyOpened];
        [self queueIncomingMessage:message];
    }
}

-(void)unregisterAppInterfacePrivate:(NSNumber*)correlationID{//TODO:Add unregAppIntCorrID
    SDLUnregisterAppInterface* msg = [SDLRPCRequestFactory buildUnregisterAppInterfaceWithCorrelationID:correlationID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SDLProxyBaseUnregisterAppInterfaceNotification"
                                                        object:@{@"RPC_NAME": NAMES_UnregisterAppInterface,
                                                                 @"TYPE": NAMES_request,
                                                                 @"CORRID": msg.correlationID,
                                                                 @"DATA": [self stringFromSerializeRPCMessage:msg]}];
    [self sendRPCRequestPrivate:msg];
}

-(void)endPutFileStream{
    [self endRPCStream];
}

-(void)endRPCStream{
    
}

-(SDLTransportType)transportType{
    return self.sdlSession.currentTransportType;
}

-(NSTimeInterval)instanceTimeInterval{
    return _instanceTimeInterval;
}

-(NSString*)stringFromSerializeRPCMessage:(SDLRPCMessage *)message{
    NSString* sReturn;
    
    //TODO:Add error handling
    sReturn = [[message serializeAsDictionary:self.wiproVersion] description];
    return sReturn;
}

#pragma mark SDLConnectionDelegate Methods

-(void)protocolMessageReceived:(SDLProtocolMessage *)msg{
    if ((msg.payload && [msg.payload length] > 0) ||
        (msg.bulkData && [msg.bulkData length] > 0)) {
        [self queueIncomingMessage:msg];
    }
}

-(void)protocolSessionStarted:(SDLServiceType)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString *)correlationID{
    self.wiproVersion = version;
    
    if (_transportConfig.heartBeatTimeout != NSIntegerMax && version > 2) {
        SDLHeartbeatMonitor* heartbeatMonitor = [SDLHeartbeatMonitor new];
        heartbeatMonitor.interval = _transportConfig.heartBeatTimeout;
        self.sdlSession.heartbeatMonitor = heartbeatMonitor;
    }
    
    if (sessionType==SDLServiceType_RPC) {
        [self startRPCProtocolSession:sessionID correlationID:correlationID];
    }
    else if (sessionType==SDLServiceType_Nav){
        [self navServiceStarted];
    }
    else if (_wiproVersion > 1){
        [self startRPCProtocolSession:sessionID correlationID:correlationID];
    }
}

-(void)onTransportDisconnected{
    if (!self.isAdvancedLifecycleManagementEnabled) {
        //TODO:Add error
        [self notifyProxyClosedWithInfo:NSStringFromSelector(_cmd) error:nil reason:SDLDisconnectReasonTransportDisconnected];//TODO:Add paramters
    }
}

-(void)onTransportError:(NSError*)error{
    //TODO: SDLDebugTool logInfo:error: does not exist.
    //    SDLDebugTool logInfo:
    if (self.advancedLifecycleManagementEnabled) {
        [self cycleProxy:SDLDisconnectReasonTransportError];
    }
    else{
        [self notifyProxyClosedWithInfo:NSStringFromSelector(_cmd) error:error reason:SDLDisconnectReasonTransportError];
    }
}

-(void)onProtocolMessageReceived:(SDLProtocolMessage*)msg{
    //TODO:msg.bulkData does not exist yet
    if ((msg.data && msg.data.length > 0) /*|| (msg.bulkData && msg.bulkData.length > 0)*/) {
        [self queueIncomingMessage:msg];
    }
}

-(void)queueInternalMessage:(SDLProtocolMessage*)message{
    
}

-(void)queueIncomingMessage:(SDLProtocolMessage*)message{
//    [self.internalProxyMessageDispatcher queueMessage:message];
//    [self dispatchIncomingMessage:message];
//    [self handleProtocolMessage:message];
    [self handleRPCMessage:[message rpcDictionary]];
}

-(void)onProtocolSessionNACKed:(SDLSessionType*)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationID{
    
}

-(void)onProtocolSessionEnded:(SDLSessionType*)sessionType sessionID:(Byte)sessionID correlationID:(NSString*)correlationID{
    
}

-(void)onProtocolError:(NSError*)error{
    
}

-(void)onHeartbeatTimedOut:(Byte)sessionID{
    
}

-(BOOL)isCorrelationIDProtected:(NSNumber*)correlationID{
    if (correlationID &&
        (  [correlationID intValue] == HEARTBEAT_CORRELATION_ID
        || [correlationID intValue] == REGISTER_APP_INTERFACE_CORRELATION_ID
        || [correlationID intValue] == UNREGISTER_APP_INTERFACE_CORRELATION_ID
        || [correlationID intValue] == POLICIES_CORRELATION_ID)){
        return YES;
    }
    return NO;
}

-(BOOL)isConnected{
    if (!self.sdlSession) {
        return NO;
    }
    
    return self.sdlSession.isConnected;
}

-(void)dispatchOutgoingMessage:(SDLRPCRequest*)message{
    if (self.sdlSession) {
        [self.sdlSession sendMessage:message];
    }
}

-(void)handleErrorsFromInternalMessageDispatcher:(NSString*)info exception:(NSException*)exception{
    //TODO: Not all references to this method currently send info.
    //TODO: Does info string need to sent here as well?
    [SDLDebugTool logInfo:@"InternalMessageDispatcher failed."];
    //TODO: Remove all references to NSException?
    [self notifyProxyClosedWithInfo:info error:nil reason:SDLDisconnectReasonGenericError];
    [self invokeMethodOnDelegates:@selector(onError:) withObject:exception];
}

-(void)handleErrorsFromIncomingMessageDispatcher:(NSError*)error{
    [self passErrorToProxyListener:error];
}

-(void)handleErrorsFromOutgoingMessageDispatcher:(NSError*)error{
    [self passErrorToProxyListener:error];
}

-(void)passErrorToProxyListener:(NSError*)error{
    
    SDLOnError* message = [[SDLOnError alloc] initWithError:error];
    
    [self queueIncomingMessage:message];
}

#pragma mark SDLProtocolListener Delegate Methods

- (void)handleProtocolSessionStarted:(SDLServiceType)sessionType sessionID:(Byte)sessionID version:(Byte)version {
    
    [SDLDebugTool logInfo:@"SDLProxyBase recieved handleProtocolSessionStarted"];
    
    NSAssert(0==1, @"SDLProxyBase recieved handleProtocolSessionStarted");
    
    self.wiproVersion = version;
    
    if (_transportConfig.heartBeatTimeout != NSIntegerMax && version > 2) {
        SDLHeartbeatMonitor* heartbeatMonitor = [SDLHeartbeatMonitor new];
        heartbeatMonitor.interval = _transportConfig.heartBeatTimeout;
        self.sdlSession.heartbeatMonitor = heartbeatMonitor;
    }
    
    if (sessionType == SDLServiceType_RPC) {
        [self startRPCProtocolSession:sessionID correlationID:nil];
    }
    else if (sessionType ==SDLServiceType_Nav){
        [self navServiceStarted];
    }
    else if (_wiproVersion > 1){
        [self startRPCProtocolSession:sessionID correlationID:nil];
    }
}

@end
