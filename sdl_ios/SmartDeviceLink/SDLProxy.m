//  SDLProxy.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

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


#define VERSION_STRING @"SmartDeviceLink-20140929-090241-LOCAL-iOS"

@interface SDLProxy ()

{
    SDLLockScreenManager *lsm;
}
- (void)invokeMethodOnDelegates:(SEL)aSelector withObject:(id)object;
- (void)notifyProxyClosed;
- (void)handleProtocolMessage:(SDLProtocolMessage *)msgData;
- (void)SyncPDataNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error;
- (void)SystemRequestNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error;

@end



@implementation SDLProxy

const float handshakeTime = 30.0;
const float notifyProxyClosedDelay = 0.1;
const int POLICIES_CORRELATION_ID = 65535;


#pragma mark - Object lifecycle
- (id)initWithTransport:(NSObject<SDLTransport> *)theTransport protocol:(NSObject<SDLInterfaceProtocol> *)theProtocol delegate:(NSObject<SDLProxyListener> *)theDelegate {
	if (self = [super init]) {
        _debugConsoleGroupName = @"default";
        

        lsm = [SDLLockScreenManager new];

        rpcSessionID = 0;
        alreadyDestructed = NO;
                
        self.proxyListeners = [[NSMutableArray alloc] initWithObjects:theDelegate, nil];
        self.protocol = theProtocol;
        self.transport = theTransport;
        self.transport.delegate = self.protocol;
        self.protocol.protocolDelegate = self;
        self.protocol.transport = self.transport;
        [self.transport connect];

        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];

    }

    return self;
}

-(void) destructObjects {
    if(!alreadyDestructed) {
        alreadyDestructed = YES;

        [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
        
        self.transport = nil;
        self.protocol = nil;
        self.proxyListeners = nil;

        [self destroyHandshakeTimer];
    }
}

-(void) dispose {
    [self destructObjects];
}

-(void) dealloc {
    [self destructObjects];
}

-(void) notifyProxyClosed {
	if (isConnected) {
		isConnected = NO;
        [self invokeMethodOnDelegates:@selector(onProxyClosed) withObject:nil];
	}
}


#pragma mark - Pseudo properties
- (NSObject<SDLTransport> *)getTransport {
    return self.transport;// not needed except for backwards compatability?
}

- (NSObject<SDLInterfaceProtocol> *)getProtocol {
    return self.protocol;// not needed except for backwards compatability?
}

- (NSString *)getProxyVersion {
    return VERSION_STRING;
}

- (NSString *)proxyVersion { // How it should have been named.
    return VERSION_STRING;
}


#pragma mark - Handshake Timer
- (void)handshakeTimerFired {
    [SDLDebugTool logInfo:@"RPC Initial Handshake Timeout" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    [self destroyHandshakeTimer];
    [self performSelector:@selector(notifyProxyClosed) withObject:nil afterDelay:notifyProxyClosedDelay];
}

-(void)destroyHandshakeTimer {
    if (self.handshakeTimer != nil) {
        [self.handshakeTimer invalidate];
        self.handshakeTimer = nil;
    }
}


#pragma mark - SDLProtocolListener Implementation
- (void) onProtocolOpened {
    isConnected = YES;
    [SDLDebugTool logInfo:@"StartSession (request)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    [self.protocol sendStartSessionWithType:SDLServiceType_RPC];

    [self destroyHandshakeTimer];
    self.handshakeTimer = [NSTimer scheduledTimerWithTimeInterval:handshakeTime target:self selector:@selector(handshakeTimerFired) userInfo:nil repeats:NO];
}

-(void) onProtocolClosed {
	[self notifyProxyClosed];
}

-(void) onError:(NSString*) info exception:(NSException*) e {
    [self invokeMethodOnDelegates:@selector(onError:) withObject:e];
}

- (void)handleProtocolSessionStarted:(SDLServiceType)sessionType sessionID:(Byte)sessionID version:(Byte)maxVersionForModule {
    NSString *logMessage = [NSString stringWithFormat:@"StartSession (response)\nSessionId: %d", sessionID];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    if (_version <= 1) {
        if (maxVersionForModule == 2) {
            _version = maxVersionForModule;
        }
    }

    if (sessionType == SDLServiceType_RPC || _version == 2) {
        rpcSessionID = sessionID;
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
        [self sendRPC:msg];
    }
}

- (void)handleProtocolMessage:(SDLProtocolMessage *)incomingMessage {
    // Convert protocol message to dictionary
    NSDictionary* rpcMessageAsDictionary = [incomingMessage rpcDictionary];
    [self handleRpcMessage:rpcMessageAsDictionary];
}

- (void)handleRPCMessage:(SDLRPCMessage *)message {
    NSString* functionName = [rpcMsg getFunctionName];
    NSString* messageType = [rpcMsg messageType];
    
    // From the function name, create the corresponding RPCObject and initialize it
    NSString* functionClassName = [NSString stringWithFormat:@"SDL%@", functionName];
    SDLRPCMessage *newMessage = [[NSClassFromString(functionClassName) alloc] initWithDictionary:msg];
    
    // Log the RPC message out
    NSString *logMessage = [NSString stringWithFormat:@"%@", newMessage];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    
    // Intercept and handle ourselves a bunch of things
    if ([functionName isEqualToString:NAMES_OnAppInterfaceUnregistered]
        || [functionName isEqualToString:NAMES_UnregisterAppInterface]) {
        [self handleRPCUnregistered:newMessage];
        return;
    }
    
    if ([messageType isEqualToString:NAMES_response]) {
        BOOL notGenericResponseMessage = ![functionName isEqualToString:@"GenericResponse"];
        if(notGenericResponseMessage) {
            [newMessage setFunctionName:[NSString stringWithFormat:@"%@Response", functionName]];
        } else {
            return;
        }
    }
    
    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
        [self handleRegisterAppInterfaceResponse:newMessage];
        return;
    }
    
    if ([functionName isEqualToString:@"EncodedSyncPDataResponse"]) {
        [SDLDebugTool logInfo:@"EncodedSyncPData (response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    if ([functionName isEqualToString:@"OnEncodedSyncPData"]) {
        [self handleSyncPData:newMessage];
        return;
    }
    
    if ([functionName isEqualToString:@"OnSystemRequest"]) {
        [self handleSystemRequest:newMessage];
        return;
    }
    
    if ([functionName isEqualToString:@"SystemRequestResponse"]) {
        [self handleSystemRequestResponse:newMessage];
        return;
    }
    
    // Formulate the name of the method to call and invoke the method on the delegate(s)
    NSString* handlerName = [NSString stringWithFormat:@"on%@:", functionName];
    SEL handlerSelector = NSSelectorFromString(handlerName);
    [self invokeMethodOnDelegates:handlerSelector withObject:newMessage];
    
    // When an OnHMIStatus notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnHMIStatus"]) {
        [self handleAfterHMIStatus:newMessage];
    }
    
    // When an OnDriverDistraction notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnDriverDistraction"]) {
        [self handleAfterDriverDistraction:message];
    }
}

- (void)handleRpcMessage:(NSDictionary*) msg {
    SDLRPCMessage *message = [[SDLRPCMessage alloc] initWithDictionary:(NSMutableDictionary*) msg];
    [self handleRPCMessage:message];
}


#pragma mark - RPC Handlers
- (void)handleRPCUnregistered:(SDLRPCMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"Unregistration forced by module. %@", msg];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC  toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    [self notifyProxyClosed];
}

- (void)handleRegisterAppInterfaceResponse:(SDLRPCResponse *)response {
    // Turn off the timer, the handshake has succeeded
    [self destroyHandshakeTimer];
    
    //Print Proxy Version To Console
    NSString *logMessage = [NSString stringWithFormat:@"Framework Version: %@", [self getProxyVersion]];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

- (void)handleSyncPData:(SDLRPCMessage *)message {
    // If URL != nil, perform HTTP Post and don't pass the notification to FMProxyListeners
    NSString *logMessage = [NSString stringWithFormat:@"OnEncodedSyncPData (notification)\n%@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    NSString *urlString = (NSString *)[message getParameters:@"URL"];
    NSDictionary *encodedSyncPData = (NSDictionary *)[message getParameters:@"data"];
    NSNumber *encodedSyncPTimeout = (NSNumber *)[message getParameters:@"Timeout"];
    
    if (urlString && encodedSyncPData && encodedSyncPTimeout) {
        [self sendEncodedSyncPData:encodedSyncPData toURL:urlString withTimeout:encodedSyncPTimeout];
    }
}

- (void)handleSystemRequest:(SDLRPCMessage *)message {
    
    [SDLDebugTool logInfo:@"OnSystemRequest (notification)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    SDLOnSystemRequest* systemRequest = [[SDLOnSystemRequest alloc] initWithDictionary:(NSMutableDictionary*) message];
    SDLRequestType *requestType = systemRequest.requestType;
    
    // Handle the various OnSystemRequest types
    if (requestType == [SDLRequestType PROPRIETARY]) {
        [self handleSystemRequestProprietary:systemRequest];
    } else if (requestType == [SDLRequestType QUERY_APPS]) {
        [self handleSystemRequestQueryApps:systemRequest];
    } else if (requestType == [SDLRequestType LAUNCH_APP]) {
        [self handleSystemRequestLaunchApp:systemRequest];
    }
}

- (void)handleSystemRequestResponse:(SDLRPCMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"SystemRequest (response)\n%@", msg];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}


#pragma mark Handle Post-Invoke of Delegate Methods
- (void)handleAfterHMIStatus:(SDLRPCMessage *)message {
    NSString *statusString = (NSString *)[message getParameters:NAMES_hmiLevel];
    SDLHMILevel *hmiLevel = [SDLHMILevel valueOf:statusString];
    lsm.hmiLevel = hmiLevel;
    
    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self invokeMethodOnDelegates:callbackSelector withObject:lsm.lockScreenStatusNotification];
}

- (void)handleAfterDriverDistraction:(SDLRPCMessage *)message {
    NSString *stateString = (NSString *)[message getParameters:NAMES_state];
    BOOL state = [stateString isEqualToString:@"DD_ON"]?YES:NO;
    lsm.bDriverDistractionStatus = state;
    
    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self invokeMethodOnDelegates:callbackSelector withObject:lsm.lockScreenStatusNotification];
}


#pragma mark OnSystemRequest Handlers

- (void)handleSystemRequestProprietary:(SDLOnSystemRequest *)request {
    NSString *urlString = request.url;
    SDLFileType *fileType = request.fileType;
    
    // Validate input
    if (urlString == nil) {
        [SDLDebugTool logInfo:@"OnSystemRequest (notification) failure: url is nil" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        
        return;
    }
    
    if (fileType != [SDLFileType JSON]) {
        [SDLDebugTool logInfo:@"OnSystemRequest (notification) failure: file type is not JSON" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    // Get data dictionary from the bulkData
    NSError *errorJSONSerializeNotification = nil;
    NSDictionary *notificationDictionary = [NSJSONSerialization JSONObjectWithData:systemRequest.bulkData options:kNilOptions error:&errorJSONSerializeNotification];
    if (errorJSONSerializeNotification != nil) {
        [SDLDebugTool logInfo:@"OnSystemRequest failure: notification data is not valid JSON." withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    // Extract data from the dictionary
    NSDictionary *requestData = notificationDictionary[@"HTTPRequest"];
    NSDictionary *headers = requestData[@"headers"];
    NSString *contentType = headers[@"ContentType"];
    NSTimeInterval timeout = [headers[@"ConnectTimeout"] doubleValue];
    NSString *method = headers[@"RequestMethod"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Parse and display the policy data.
    SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
    NSData *policyData = [pdp unwrap:bodyData];
    if (policyData != nil) {
        [pdp parsePolicyData:policyData];
        NSString *logMessage = [NSString stringWithFormat:@"Policy Data from Module\n%@", pdp];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    
    // HTTP Request configuration
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
    request.timeoutInterval = timeout;
    request.HTTPMethod = method;
    
    // Send the HTTP Request
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self SystemRequestNetworkRequestCompleteWithData:data response:response error:error];
    }];
    [uploadTask resume];
    
    // Logging
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request) to URL %@", urlString];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

- (void)handleSystemRequestQueryApps:(SDLOnSystemRequest *)request {
    
}

- (void)handleSystemRequestLaunchApp:(SDLOnSystemRequest *)request {
    
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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

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
    
    // Send the HTTP Request
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self SyncPDataNetworkRequestCompleteWithData:data response:response error:error];
    }];
    [uploadTask resume];
    
    [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP request)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

// Handle the OnEncodedSyncPData HTTP Response
- (void)SyncPDataNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
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
- (void)SystemRequestNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {

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

    // Send and log RPC Request
    logMessage = [NSString stringWithFormat:@"SystemRequest (request)\n%@\nData length=%lu", [request serializeAsDictionary:2], (unsigned long)data.length ];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    [self sendRPCRequestPrivate:request];

}


#pragma mark - PutFile Streaming
- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest
{
    [self putFileStream:inputStream withRequest:putFileRPCRequest];
}

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest
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
