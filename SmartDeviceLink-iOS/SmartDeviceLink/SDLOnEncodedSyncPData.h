//  SDLOnEncodedSyncPData.h
//


#import "SDLRPCNotification.h"

@interface SDLOnEncodedSyncPData : SDLRPCNotification {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *data;
@property (strong) NSString *URL;
@property (strong) NSNumber *Timeout;

@end
