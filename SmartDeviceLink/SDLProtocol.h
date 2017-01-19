//  SDLSmartDeviceLinkProtocol.h
//

#import "SDLProtocolListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportDelegate.h"

@class SDLProtocolHeader;
@class SDLAbstractTransport;
@class SDLRPCMessage;
@class SDLRPCRequest;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SDLProtocolError) {
    SDLProtocolErrorNoSecurityManager,
};

extern NSString *const SDLProtocolSecurityErrorDomain;

@interface SDLProtocol : NSObject <SDLProtocolListener, SDLTransportDelegate>

@property (strong, nonatomic) NSString *debugConsoleGroupName;
@property (nullable, weak, nonatomic) SDLAbstractTransport *transport;
@property (nullable, strong, nonatomic) NSHashTable<id<SDLProtocolListener>> *protocolDelegateTable;
@property (nullable, nonatomic, strong) id<SDLSecurityType> securityManager;
@property (nonatomic, copy) NSString *appId;

// Sending
- (void)sendStartSessionWithType:(SDLServiceType)serviceType __deprecated_msg(("Use startServiceWithType: instead"));
- (void)startServiceWithType:(SDLServiceType)serviceType;
- (void)startSecureServiceWithType:(SDLServiceType)serviceType completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType __deprecated_msg(("Use endServiceWithType: instead"));
- (void)endServiceWithType:(SDLServiceType)serviceType;
- (void)sendRPC:(SDLRPCMessage *)message;
- (BOOL)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError **)error;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest __deprecated_msg(("Use sendRPC: instead"));
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;
- (void)sendEncryptedRawData:(NSData *)data onService:(SDLServiceType)serviceType;

// Recieving
- (void)handleBytesFromTransport:(NSData *)receivedData;

@end

NS_ASSUME_NONNULL_END
