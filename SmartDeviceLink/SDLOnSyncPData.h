//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 DEPRECATED
 */
@interface SDLOnSyncPData : SDLRPCNotification

/// The url
@property (nullable, strong, nonatomic) NSString *URL;

/// How long until a timeout
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
