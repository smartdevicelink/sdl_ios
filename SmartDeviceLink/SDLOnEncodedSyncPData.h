//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"


@interface SDLOnEncodedSyncPData : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSMutableArray<NSString *> *data;
@property (strong) NSString *URL;
@property (strong) NSNumber *Timeout;

@end
