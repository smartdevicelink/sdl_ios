//
//  SDLInterfaceAvailability.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <SmartDeviceLink/SmartDeviceLink.h>

@interface SDLInterfaceAvailability : SDLEnum

+(SDLInterfaceAvailability*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLInterfaceAvailability*) AVAILABLE;
+(SDLInterfaceAvailability*) UNAVAILABLE;

@end
