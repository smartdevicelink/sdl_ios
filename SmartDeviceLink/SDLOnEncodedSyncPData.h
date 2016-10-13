//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"


@interface SDLOnEncodedSyncPData : SDLRPCNotification

@property (strong) NSMutableArray *data;
@property (strong) NSString *URL;
@property (strong) NSNumber *Timeout;

@end
