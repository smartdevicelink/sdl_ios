//  SDLRPCNotification.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLRPCNotification : SDLRPCMessage {}

- (id)initWithName:(NSString *)name;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@end
