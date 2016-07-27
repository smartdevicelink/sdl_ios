//  SDLOnSyncPData.h
//


#import "SDLRPCNotification.h"

@interface SDLOnSyncPData : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSString *URL;
@property (strong) NSNumber *Timeout;

@end
