//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

@interface SDLOnSyncPData : SDLRPCNotification

@property (strong) NSString *URL;
@property (strong) NSNumber<SDLInt> *Timeout;

@end
