//  SDLProxy.h
//

@class SDLEncryptionLifecycleManager;
@class SDLProtocol;
@class SDLPutFile;
@class SDLRPCMessage;
@class SDLSecondaryTransportManager;
@class SDLStreamingMediaManager;
@class SDLTimer;

#import "SDLProtocolDelegate.h"
#import "SDLProxyListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLProxy : NSObject <SDLProtocolDelegate, NSStreamDelegate> {
    Byte _version;
    Byte _bulkSessionID;
    BOOL _isConnected;
}

/**
 *  The proxy version number.
 */
@property (readonly, copy, nonatomic) NSString *proxyVersion;

@end

NS_ASSUME_NONNULL_END
