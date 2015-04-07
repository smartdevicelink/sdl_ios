//
//  SDLInterfaceAvailability.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLInterfaceAvailability.h"

SDLInterfaceAvailability* sdlInterfaceAvailability_UNAVAILABLE = nil;
SDLInterfaceAvailability* sdlInterfaceAvailability_AVAILABLE = nil;

@implementation SDLInterfaceAvailability

+(SDLInterfaceAvailability*) valueOf:(NSString*) value {
    for (SDLInterfaceAvailability* item in SDLInterfaceAvailability.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSArray*) values {
    return @[SDLInterfaceAvailability.UNAVAILABLE,
             SDLInterfaceAvailability.AVAILABLE];
}

+(SDLInterfaceAvailability *)UNAVAILABLE{
        if (sdlInterfaceAvailability_UNAVAILABLE == nil) {
            sdlInterfaceAvailability_UNAVAILABLE = [[SDLInterfaceAvailability alloc] initWithValue:@"UNAVAILABLE"];
        }
        return sdlInterfaceAvailability_UNAVAILABLE;
}

+(SDLInterfaceAvailability *)AVAILABLE{
    if (sdlInterfaceAvailability_AVAILABLE == nil) {
        sdlInterfaceAvailability_AVAILABLE = [[SDLInterfaceAvailability alloc] initWithValue:@"AVAILABLE"];
    }
    return sdlInterfaceAvailability_AVAILABLE;
}

@end
