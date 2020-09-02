//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 DEPRECATED
 */
__deprecated
@interface SDLOnSyncPData : SDLRPCNotification

/// The url
///
/// Optional
@property (nullable, strong, nonatomic) NSString *URL;

/// How long until a timeout
///
/// Optional
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
