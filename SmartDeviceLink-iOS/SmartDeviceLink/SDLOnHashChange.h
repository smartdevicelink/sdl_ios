//  SDLOnHashChange.h
//


#import "SDLRPCNotification.h"

@interface SDLOnHashChange : SDLRPCNotification {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSString *hashID;

@end
