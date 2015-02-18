//  SDLProxy.h
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//  Version: AppLink-20141001-130610-LOCAL-iOS

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProxyListener.h>
#import <SmartDeviceLink/SDLRPCRequestFactory.h>
#import "SDLAbstractProtocol.h"
#import "SDLAbstractTransport.h"
#import "SDLTimer.h"

@interface SDLProxy : NSObject <SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
    Byte bulkSessionID;
    BOOL isConnected;
    BOOL _alreadyDestructed;

}

@property (strong) SDLAbstractProtocol *protocol;
@property (strong) SDLAbstractTransport *transport;
@property (strong) NSMutableArray *proxyListeners;
@property (strong) SDLTimer *startSessionTimer;
@property (strong) NSString *debugConsoleGroupName;
@property (readonly) NSString *proxyVersion;

- (id)initWithTransport:(SDLAbstractTransport *)transport
               protocol:(SDLAbstractProtocol *)protocol
               delegate:(NSObject<SDLProxyListener> *)delegate;

- (void)dispose;
- (void)addDelegate:(NSObject<SDLProxyListener> *)delegate;

- (void)sendRPCRequest:(SDLRPCMessage *)msg;
- (void)handleRpcMessage:(NSDictionary *)msg;
- (void)handleProtocolMessage:(SDLProtocolMessage *)msgData;

- (void)startAudioSession;
- (void)sendAudioData:(NSData *)data;
- (void)startVideoSession;
- (void)sendVideoData:(NSData *)data;

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

+ (void)enableSiphonDebug;
+ (void)disableSiphonDebug;


@end
