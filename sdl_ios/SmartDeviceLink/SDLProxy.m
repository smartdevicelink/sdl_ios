//  SDLProxy.m
//
//  

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import <objc/runtime.h>
#import <SmartDeviceLink/SDLDebugTool.h>
#import <SmartDeviceLink/SDLEncodedSyncPData.h>
#import <SmartDeviceLink/SDLFunctionID.h>
#import <SmartDeviceLink/SDLJsonDecoder.h>
#import <SmartDeviceLink/SDLJsonEncoder.h>
#import <SmartDeviceLink/SDLLanguage.h>
#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLSiphonServer.h>
#import <SmartDeviceLink/SDLProxy.h>
#import <SmartDeviceLink/SDLSystemRequest.h>
#import "SDLRPCPayload.h"
#import "SDLPolicyDataParser.h"
#import "SDLLockScreenManager.h"
#import "SDLProtocolMessage.h"


#define VERSION_STRING @"##Version##"
typedef void(^SDLCustomTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);


@interface SDLProxy ()

{
    SDLLockScreenManager *lsm;
    NSURLSession *systemRequestSession;
    NSURLSession *encodedSyncPDataSession;
}

- (void)startRPCSession;
- (void)invokeMethodOnDelegates:(SEL)aSelector withObject:(id)object;
- (void)notifyProxyClosed;
- (void)handleProtocolMessage:(SDLProtocolMessage *)msgData;
- (void)OESPHTTPRequestCompletionHandler:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error;
- (void)OSRHTTPRequestCompletionHandler:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error;
- (void)sendDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType;

@end



@implementation SDLProxy

const float startSessionTime = 10.0;
const float notifyProxyClosedDelay = 0.1;
const int POLICIES_CORRELATION_ID = 65535;


#pragma mark - Object lifecycle
- (id)initWithTransport:(SDLAbstractTransport *)theTransport protocol:(SDLAbstractProtocol *)theProtocol delegate:(NSObject<SDLProxyListener> *)theDelegate {
    if (self = [super init]) {
        _debugConsoleGroupName = @"default";


        lsm = [SDLLockScreenManager new];

        _alreadyDestructed = NO;

        self.proxyListeners = [[NSMutableArray alloc] initWithObjects:theDelegate, nil];
        self.protocol = theProtocol;
        self.transport = theTransport;
        self.transport.delegate = self.protocol;
        self.protocol.protocolDelegate = self;
        self.protocol.transport = self.transport;

        [self.transport performSelector:@selector(connect) withObject:nil afterDelay:0];

        [SDLDebugTool logInfo:@"SDLProxy initWithTransport"];
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];

    }

    return self;
}

-(void) destructObjects {
    if(!_alreadyDestructed) {
        _alreadyDestructed = YES;

        if (systemRequestSession != nil) {
            [systemRequestSession invalidateAndCancel];
        }
        if (encodedSyncPDataSession != nil) {
            [encodedSyncPDataSession invalidateAndCancel];
        }

        [self.protocol dispose];
        [self.transport dispose];
        [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
        self.transport = nil;
        self.protocol = nil;
        self.proxyListeners = nil;
    }
}

-(void) dispose {
    [self destructObjects];
}

-(void) dealloc {
    [self destructObjects];
    [SDLDebugTool logInfo:@"SDLProxy Dealloc" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:_debugConsoleGroupName];
}

-(void) notifyProxyClosed {
    if (isConnected) {
        isConnected = NO;
        [self invokeMethodOnDelegates:@selector(onProxyClosed) withObject:nil];
    }
}

- (NSString *)proxyVersion {
    return VERSION_STRING;
}

- (void)startRPCSession {
    [self.protocol sendStartSessionWithType:SDLServiceType_RPC];
}

#pragma mark - SDLProtocolListener Implementation
- (void) onProtocolOpened {
    isConnected = YES;
    [SDLDebugTool logInfo:@"StartSession (request)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    [self startRPCSession];

    if (self.startSessionTimer == nil) {
        self.startSessionTimer = [[SDLTimer alloc] initWithDuration:startSessionTime];
        __weak typeof(self) weakSelf = self;
        self.startSessionTimer.elapsedBlock = ^{
            [SDLDebugTool logInfo:@"Start Session Timeout" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:weakSelf.debugConsoleGroupName];
            [weakSelf performSelector:@selector(notifyProxyClosed) withObject:nil afterDelay:notifyProxyClosedDelay];
        };
    }
    [self.startSessionTimer start];
}

-(void) onProtocolClosed {
    [self notifyProxyClosed];
}

-(void) onError:(NSString*) info exception:(NSException*) e {
    [self invokeMethodOnDelegates:@selector(onError:) withObject:e];
}

- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)maxVersionForModule {
    // Turn off the timer, the start session response came back
    [self.startSessionTimer cancel];

    NSString *logMessage = [NSString stringWithFormat:@"StartSession (response)\nSessionId: %d for serviceType %d", sessionID, serviceType];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    if (_version <= 1) {
        if (maxVersionForModule == 2) {
            _version = maxVersionForModule;
        }
    }

    if (serviceType == SDLServiceType_RPC) {
        [self invokeMethodOnDelegates:@selector(onProxyOpened) withObject:nil];
    }
}

- (void) onProtocolMessageReceived:(SDLProtocolMessage*) msgData {
    @try {
        [self handleProtocolMessage:msgData];
    }
    @catch (NSException * e) {
        NSString *logMessage = [NSString stringWithFormat:@"Proxy: Failed to handle protocol message %@", e];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Debug toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
}


#pragma mark - Message sending and recieving
-(void) sendRPCRequest:(SDLRPCMessage*) msg {
    if ([msg isKindOfClass:SDLRPCRequest.class]) {
        [self sendRPCRequestPrivate:(SDLRPCRequest *)msg];
    }
}

- (void)sendRPCRequestPrivate:(SDLRPCRequest *)rpcRequest {
    @try {
        [self.protocol sendRPCRequest:rpcRequest];
    } @catch (NSException * e) {
        NSString *logMessage = [NSString stringWithFormat:@"Proxy: Failed to send RPC request: %@", rpcRequest.name];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Debug toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
}

- (void)handleProtocolMessage:(SDLProtocolMessage *)incomingMessage {
    // Convert protocol message to dictionary
    NSDictionary* rpcMessageAsDictionary = [incomingMessage rpcDictionary];
    [self handleRpcMessage:rpcMessageAsDictionary];
}


// NOTE: This is getting rather large, excellent candidate for refactoring.
-(void) handleRpcMessage:(NSDictionary*) msg {
    NSString *logMessage = nil;

    SDLRPCMessage* rpcMsg = [[SDLRPCMessage alloc] initWithDictionary:(NSMutableDictionary*) msg];
    NSString* functionName = [rpcMsg getFunctionName];
    NSString* messageType = [rpcMsg messageType];

    if ([functionName isEqualToString:NAMES_OnAppInterfaceUnregistered]
        || [functionName isEqualToString:NAMES_UnregisterAppInterface]) {
        logMessage = [NSString stringWithFormat:@"Unregistration forced by module. %@", msg];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC  toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        [self notifyProxyClosed];
        return;
    }

    if ([messageType isEqualToString:NAMES_response]) {
        bool notGenericResponseMessage = ![functionName isEqualToString:@"GenericResponse"];
        if(notGenericResponseMessage) functionName = [NSString stringWithFormat:@"%@Response", functionName];
    }


    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
        //Print Proxy Version To Console
        logMessage = [NSString stringWithFormat:@"Framework Version: %@", self.proxyVersion];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }


    if ([functionName isEqualToString:@"EncodedSyncPDataResponse"]) {
        [SDLDebugTool logInfo:@"EncodedSyncPData (response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }


    // Intercept OnEncodedSyncPData. If URL != nil, perform HTTP Post and don't pass the notification to FMProxyListeners
    if ([functionName isEqualToString:@"OnEncodedSyncPData"]) {
        logMessage = [NSString stringWithFormat:@"OnEncodedSyncPData (notification)\n%@", msg];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

        NSString     *urlString           = (NSString *)    [rpcMsg getParameters:@"URL"];
        NSDictionary *encodedSyncPData    = (NSDictionary *)[rpcMsg getParameters:@"data"];
        NSNumber     *encodedSyncPTimeout = (NSNumber *)    [rpcMsg getParameters:@"Timeout"];

        if (urlString && encodedSyncPData && encodedSyncPTimeout) {
            [self sendEncodedSyncPData:encodedSyncPData toURL:urlString withTimeout:encodedSyncPTimeout];
        }

        return;
    }

    // Intercept OnSystemRequest.
    if ([functionName isEqualToString:@"OnSystemRequest"]) {

        [SDLDebugTool logInfo:@"OnSystemRequest (notification)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

        SDLOnSystemRequest* sysRpcMsg = [[SDLOnSystemRequest alloc] initWithDictionary:(NSMutableDictionary*) msg];
        SDLRequestType *requestType = sysRpcMsg.requestType;
        NSString       *urlString   = sysRpcMsg.url;
        SDLFileType    *fileType    = sysRpcMsg.fileType;

        if (requestType == [SDLRequestType PROPRIETARY])
        {
            // Validate input
            if (urlString == nil)
            {
                [SDLDebugTool logInfo:@"OnSystemRequest (notification) failure: url is nil" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
                return;
            }
            if (fileType != [SDLFileType JSON])
            {
                [SDLDebugTool logInfo:@"OnSystemRequest (notification) failure: file type is not JSON" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
                return;
            }

            // Get data dictionary from the bulkData
            NSDictionary *notificationDictionary = nil;
            @try {
                NSError *errorJSONSerializeNotification = nil;
                notificationDictionary = [NSJSONSerialization JSONObjectWithData:sysRpcMsg.bulkData options:kNilOptions error:&errorJSONSerializeNotification];
                if (errorJSONSerializeNotification) {
                    [SDLDebugTool logInfo:@"OnSystemRequest failure: notification data is not valid JSON." withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
                    return;
                }
            }
            @catch (NSException *exception) {
                logMessage = [NSString stringWithFormat:@"Exception converting bulk data to NSDictionary. Data:\n%@", [[NSString alloc] initWithData:sysRpcMsg.bulkData encoding:NSUTF8StringEncoding]];
                [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

                [exception raise]; // rethrow
            }


            // Extract data from the dictionary
            NSDictionary   *requestData = notificationDictionary[@"HTTPRequest"];
            NSDictionary   *headers     = requestData[@"headers"];
            NSString       *contentType = headers[@"ContentType"];
            NSTimeInterval timeout      = [headers[@"ConnectTimeout"] doubleValue];
            NSString       *method      = headers[@"RequestMethod"];
            NSString       *bodyString  = requestData[@"body"];
            NSData         *bodyData    = [bodyString dataUsingEncoding:NSUTF8StringEncoding];


            // Parse and display the policy data.
            SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
            NSData *policyData = [pdp unwrap:bodyData];
            if (policyData) {
                [pdp parsePolicyData:policyData];
                logMessage = [NSString stringWithFormat:@"Policy Data from Module\n%@", pdp];
                [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            }


            // HTTP Request configuration
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            systemRequestSession = [NSURLSession sessionWithConfiguration:config];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setValue:contentType forHTTPHeaderField:@"content-type"];
            request.timeoutInterval = timeout;
            request.HTTPMethod = method;


            // Logging
            logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request) to URL %@", urlString];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];


            // Send the HTTP Request
            SDLCustomTaskCompletionHandler handler = ^void(NSData *data, NSURLResponse *response, NSError *error)
            {
                [self OSRHTTPRequestCompletionHandler:data response:response error:error];
            };
            NSURLSessionUploadTask *systemRequestUploadTask = [systemRequestSession uploadTaskWithRequest:request fromData:bodyData completionHandler:handler];
            [systemRequestUploadTask resume];

            return;
        }

    } // End of OnSystemRequest

    if ([functionName isEqualToString:@"SystemRequestResponse"]) {
        logMessage = [NSString stringWithFormat:@"SystemRequest (response)\n%@", msg];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }



    // From the function name, create the corresponding RPCObject and initialize it
    NSString* functionClassName = [NSString stringWithFormat:@"SDL%@", functionName];
    SDLRPCMessage *functionObject = [[NSClassFromString(functionClassName) alloc] initWithDictionary:msg];

    logMessage = [NSString stringWithFormat:@"%@", functionObject];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Formulate the name of the method to call on the listeners and call it, passing the RPC Object
    NSString* handlerName = [NSString stringWithFormat:@"on%@:", functionName];
    SEL handlerSelector = NSSelectorFromString(handlerName);
    [self invokeMethodOnDelegates:handlerSelector withObject:functionObject];


    // When an OnHMIStatus notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnHMIStatus"]) {
        NSString *statusString = (NSString *)[rpcMsg getParameters:NAMES_hmiLevel];
        SDLHMILevel *hmiLevel = [SDLHMILevel valueOf:statusString];
        lsm.hmiLevel = hmiLevel;

        SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
        [self invokeMethodOnDelegates:callbackSelector withObject:lsm.lockScreenStatusNotification];
    }

    // When an OnDriverDistraction notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnDriverDistraction"]) {
        NSString *stateString = (NSString *)[rpcMsg getParameters:NAMES_state];
        BOOL bState = [stateString isEqualToString:@"DD_ON"]?YES:NO;
        lsm.bDriverDistractionStatus = bState;

        SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
        [self invokeMethodOnDelegates:callbackSelector withObject:lsm.lockScreenStatusNotification];
    }

}


#pragma mark - Delegate management
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate {
    @synchronized(self.proxyListeners) {
        [self.proxyListeners addObject:delegate];
    }
}

- (void)invokeMethodOnDelegates:(SEL)aSelector withObject:(id)object {
    [self.proxyListeners enumerateObjectsUsingBlock:^(id listener, NSUInteger idx, BOOL *stop) {
        if ([(NSObject *)listener respondsToSelector:aSelector]) {
            [(NSObject *)listener performSelectorOnMainThread:aSelector withObject:object waitUntilDone:NO];
        }
    }];
}


#pragma mark - System Request and SyncP handling
-(void)sendEncodedSyncPData:(NSDictionary*)encodedSyncPData toURL:(NSString*)urlString withTimeout:(NSNumber*) timeout{

    // Configure HTTP URL & Request
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    // Configure HTTP Session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
    config.timeoutIntervalForRequest = 60;
    encodedSyncPDataSession = [NSURLSession sessionWithConfiguration:config];

    // Prepare the data in the required format
    NSString *encodedSyncPDataString = [[NSString stringWithFormat:@"%@", encodedSyncPData] componentsSeparatedByString:@"\""][1];
    NSArray *array = [NSArray arrayWithObject:encodedSyncPDataString];
    NSDictionary *dictionary = @{@"data": array};
    NSError *JSONSerializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&JSONSerializationError];
    if (JSONSerializationError) {
        NSString *logMessage = [NSString stringWithFormat:@"Error formatting data for HTTP Request. %@", JSONSerializationError];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }

    // Create the completion handler to be executed upon response
    SDLCustomTaskCompletionHandler handler = ^void(NSData *data, NSURLResponse *response, NSError *error)
    {
        [self OESPHTTPRequestCompletionHandler:data response:response error:error];
    };

    // Send the HTTP Request
    [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP request)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    NSURLSessionUploadTask *encodedSyncPDataUploadTask = [encodedSyncPDataSession uploadTaskWithRequest:request fromData:data completionHandler:handler];
    [encodedSyncPDataUploadTask resume];

}

// Handle the OnEncodedSyncPData HTTP Response
- (void)OESPHTTPRequestCompletionHandler:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    // Sample of response: {"data":["SDLKGLSDKFJLKSjdslkfjslkJLKDSGLKSDJFLKSDJF"]}
    [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Validate response data.
    if (data == nil || data.length == 0) {
        [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP response) failure: no data returned" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }

    // Convert data to RPCRequest
    NSError *JSONConversionError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONConversionError];
    if (!JSONConversionError) {
        SDLEncodedSyncPData *request = [[SDLEncodedSyncPData alloc] init];
        request.correlationID = [NSNumber numberWithInt:POLICIES_CORRELATION_ID];
        request.data = [responseDictionary objectForKey:@"data"];

        [self sendRPCRequestPrivate:request];
    }

}

// Handle the OnSystemRequest HTTP Response
- (void)OSRHTTPRequestCompletionHandler:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {

    NSString *logMessage = nil;

    if (error) {
        logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP response) = ERROR: %@", error];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }

    if (data == nil || data.length == 0) {
        [SDLDebugTool logInfo:@"OnSystemRequest (HTTP response) failure: no data returned" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }

    // Show the HTTP response
    [SDLDebugTool logInfo:@"OnSystemRequest (HTTP response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Create the SystemRequest RPC to send to module.
    SDLSystemRequest *request = [[SDLSystemRequest alloc] init];
    request.correlationID = [NSNumber numberWithInt:POLICIES_CORRELATION_ID];
    request.requestType = [SDLRequestType PROPRIETARY];
    request.bulkData = data;

    // Parse and display the policy data.
    SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
    NSData *policyData = [pdp unwrap:data];
    if (policyData) {
        [pdp parsePolicyData:policyData];
        logMessage = [NSString stringWithFormat:@"Policy Data from Cloud\n%@", pdp];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }

    // Send RPC Request
    [self sendRPCRequestPrivate:request];

}


#pragma mark - PutFile Streaming
- (void)sendDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType {

    [self.protocol sendRawDataStream:inputStream withServiceType:serviceType];
}

- (void)putFileStream:(NSInputStream*)inputStream withRequest:(SDLPutFile*)putFileRPCRequest
{
    inputStream.delegate = self;
    objc_setAssociatedObject(inputStream, @"SDLPutFile", putFileRPCRequest, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(inputStream, @"BaseOffset", [putFileRPCRequest offset], OBJC_ASSOCIATION_RETAIN);

    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{

    switch(eventCode)
    {
        case NSStreamEventHasBytesAvailable:
        {
            // Grab some bytes from the stream and send them in a SDLPutFile RPC Request
            NSUInteger currentStreamOffset = [[stream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedIntegerValue];

            const int bufferSize = 1024;
            uint8_t buf[bufferSize];
            NSUInteger len = [(NSInputStream *)stream read:buf maxLength:bufferSize];
            if(len > 0)
            {
                NSData* data = [NSData dataWithBytes:buf length:len];
                NSUInteger baseOffset = [(NSNumber*)objc_getAssociatedObject(stream, @"BaseOffset") unsignedIntegerValue];
                NSUInteger newOffset = baseOffset + currentStreamOffset;

                SDLPutFile* putFileRPCRequest = (SDLPutFile*)objc_getAssociatedObject(stream, @"SDLPutFile");
                [putFileRPCRequest setOffset:[NSNumber numberWithUnsignedInteger:newOffset]];
                [putFileRPCRequest setLength:[NSNumber numberWithUnsignedInteger:len]];
                [putFileRPCRequest setBulkData:data];

                [self sendRPCRequest:putFileRPCRequest];

            }

            break;
        }
        case NSStreamEventEndEncountered:
        {
            // Cleanup the stream
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            [SDLDebugTool logInfo:@"Stream Event: Error" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark - Siphon management
+(void)enableSiphonDebug {
    [SDLSiphonServer enableSiphonDebug];
}

+(void)disableSiphonDebug {
    [SDLSiphonServer disableSiphonDebug];
}

@end
