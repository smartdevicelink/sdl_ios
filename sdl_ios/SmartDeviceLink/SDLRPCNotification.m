//  SDLRPCNotification.m
//
//  

#import <SmartDeviceLink/SDLRPCNotification.h>
#import "SDLNames.h"

@implementation SDLRPCNotification

- (id)initWithName:(NSString *)name
{
    if (self = [super initWithName:name])
    {
        messageType = NAMES_notification;
    }
    return self;
}

- (id)initWithDictionary:(NSMutableDictionary*) dict
{
    if (self = [super initWithDictionary:dict])
    {
        messageType = NAMES_notification;
    }
    return self;
}

@end
