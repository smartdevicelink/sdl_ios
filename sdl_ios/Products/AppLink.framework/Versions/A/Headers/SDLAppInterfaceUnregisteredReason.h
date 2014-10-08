//  SDLAppInterfaceUnregisteredReason.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLAppInterfaceUnregisteredReason : SDLEnum {}

+(SDLAppInterfaceUnregisteredReason*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLAppInterfaceUnregisteredReason*) IGNITION_OFF;
+(SDLAppInterfaceUnregisteredReason*) BLUETOOTH_OFF;
+(SDLAppInterfaceUnregisteredReason*) USB_DISCONNECTED;
+(SDLAppInterfaceUnregisteredReason*) REQUEST_WHILE_IN_NONE_HMI_LEVEL;
+(SDLAppInterfaceUnregisteredReason*) TOO_MANY_REQUESTS;
+(SDLAppInterfaceUnregisteredReason*) DRIVER_DISTRACTION_VIOLATION;
+(SDLAppInterfaceUnregisteredReason*) LANGUAGE_CHANGE;
+(SDLAppInterfaceUnregisteredReason*) MASTER_RESET;
+(SDLAppInterfaceUnregisteredReason*) FACTORY_DEFAULTS;
+(SDLAppInterfaceUnregisteredReason*) APP_UNAUTHORIZED;

@end
