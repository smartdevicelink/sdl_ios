//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

@interface SDLOnSyncPData : SDLRPCNotification

@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end
