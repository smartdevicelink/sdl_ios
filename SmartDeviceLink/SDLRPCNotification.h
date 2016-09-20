//  SDLRPCNotification.h
//


#import "SDLRPCMessage.h"

@interface SDLRPCNotification : SDLRPCMessage {
}

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@end
