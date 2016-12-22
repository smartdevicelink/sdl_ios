//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnSyncPData : SDLRPCNotification

@property (nullable, strong) NSString *URL;
@property (nullable, strong) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
