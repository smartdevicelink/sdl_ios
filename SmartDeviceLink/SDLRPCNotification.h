//  SDLRPCNotification.h
//


#import "SDLRPCMessage.h"

@interface SDLRPCNotification : SDLRPCMessage {
}

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
