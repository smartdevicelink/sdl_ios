//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnEncodedSyncPData : SDLRPCNotification

@property (strong, nonatomic) NSArray<NSString *> *data;
@property (nullable, strong, nonatomic) NSString *URL;
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
