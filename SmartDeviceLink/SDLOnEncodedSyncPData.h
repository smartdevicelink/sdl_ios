//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"


@interface SDLOnEncodedSyncPData : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *data;
@property (strong) NSString *URL;
@property (strong) NSNumber *Timeout;

@end
