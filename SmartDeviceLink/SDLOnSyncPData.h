//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 DEPRECATED
 */
@interface SDLOnSyncPData : SDLRPCNotification

@property (nullable, strong, nonatomic) NSString *URL;
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
