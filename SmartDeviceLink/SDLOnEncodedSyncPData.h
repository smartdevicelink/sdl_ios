//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnEncodedSyncPData : SDLRPCNotification

@property (strong) NSMutableArray<NSString *> *data;
@property (nullable, strong) NSString *URL;
@property (nullable, strong) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
