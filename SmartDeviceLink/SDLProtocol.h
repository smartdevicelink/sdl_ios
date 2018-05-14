//  SDLSmartDeviceLinkProtocol.h
//

#import <Foundation/Foundation.h>

#import "SDLTransportType.h"
#import "SDLProtocolConstants.h"
#import "SDLProtocolListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportDelegate.h"

@class SDLProtocolHeader;
@class SDLProtocolRecievedMessageRouter;
@class SDLRPCMessage;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SDLProtocolError) {
    SDLProtocolErrorNoSecurityManager,
};

extern NSString *const SDLProtocolSecurityErrorDomain;


@interface SDLProtocol : NSObject <SDLProtocolListener, SDLTransportDelegate>

@property (strong, nonatomic) NSString *debugConsoleGroupName;
@property (nullable, weak, nonatomic) id<SDLTransportType> transport;
@property (nullable, strong, nonatomic) NSHashTable<id<SDLProtocolListener>> *protocolDelegateTable;
@property (nullable, nonatomic, strong) id<SDLSecurityType> securityManager;
@property (nonatomic, copy) NSString *appId;

// Sending
- (void)startServiceWithType:(SDLServiceType)serviceType payload:(nullable NSData *)payload;
- (void)startSecureServiceWithType:(SDLServiceType)serviceType payload:(nullable NSData *)payload completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
- (void)endServiceWithType:(SDLServiceType)serviceType;
- (void)sendRPC:(SDLRPCMessage *)message;
- (BOOL)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError **)error;
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;
- (void)sendEncryptedRawData:(NSData *)data onService:(SDLServiceType)serviceType;

// Recieving
- (void)handleBytesFromTransport:(NSData *)receivedData;

@end

NS_ASSUME_NONNULL_END
