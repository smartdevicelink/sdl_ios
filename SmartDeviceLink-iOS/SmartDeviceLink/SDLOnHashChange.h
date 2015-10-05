//  SDLOnHashChange.h
//


#import "SDLRPCNotification.h"

@interface SDLOnHashChange : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSString *hashID;

@end
