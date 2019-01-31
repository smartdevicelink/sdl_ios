//  SDLIAPTransport.h
//

#import <ExternalAccessory/ExternalAccessory.h>

#import "SDLTransportType.h"
#import "SDLIAPSessionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPTransport : NSObject <SDLTransportType, SDLIAPSessionDelegate>

/**
 *  Session for establishing a connection with Core. Once the connection has been established, the session is closed and a session is established. A `controlSession` is not needed if the  head unit supports the multisession protocol string.
 */
@property (nullable, strong, nonatomic) SDLIAPSession *controlSession;

/**
 *  Session for transporting data between the app and Core.
 */
@property (nullable, strong, nonatomic) SDLIAPSession *session;

/**
 *  The subscribed listener.
 */
@property (nullable, weak, nonatomic) id<SDLTransportDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
