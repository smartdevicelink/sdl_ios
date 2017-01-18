//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"


@interface SDLOnEncodedSyncPData : SDLRPCNotification

@property (strong, nonatomic) NSMutableArray<NSString *> *data;
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end
