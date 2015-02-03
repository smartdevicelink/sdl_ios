//  SDLProxy.h
//
//  
//  Version: ##Version##

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProxyListener.h>
#import <SmartDeviceLink/SDLRPCRequestFactory.h>
#import <SmartDeviceLink/SDLTransport.h>
#import "SDLAbstractProtocol.h"

@interface SDLProxy : NSObject<SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
    Byte bulkSessionID;
	BOOL isConnected;
    BOOL alreadyDestructed;

}

@property (strong) SDLAbstractProtocol* protocol;
@property (strong) NSObject<SDLTransport>* transport;
@property (strong) NSMutableArray* proxyListeners;
@property (strong) NSTimer* handshakeTimer;
@property (strong) NSString *debugConsoleGroupName;

-(id) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(SDLAbstractProtocol *)protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

-(NSString*) getProxyVersion;

-(void) destroyHandshakeTimer;
-(void) handleProtocolMessage:(SDLProtocolMessage*) msgData;

+(void)enableSiphonDebug;
+(void)disableSiphonDebug;

-(NSObject<SDLTransport>*)getTransport;
-(SDLAbstractProtocol*)getProtocol;

- (void)putFileStream:(NSInputStream*)inputStream withRequest:(SDLPutFile*)putFileRPCRequest;

@end
