//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

@interface SDLOnSyncPData : SDLRPCNotification {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSString *URL;
@property (strong) NSNumber *Timeout;

@end
