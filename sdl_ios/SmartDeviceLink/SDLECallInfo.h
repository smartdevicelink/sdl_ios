//  SDLECallInfo.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLVehicleDataNotificationStatus.h"
#import "SDLECallConfirmationStatus.h"

@interface SDLECallInfo : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataNotificationStatus* eCallNotificationStatus;
@property(strong) SDLVehicleDataNotificationStatus* auxECallNotificationStatus;
@property(strong) SDLECallConfirmationStatus* eCallConfirmationStatus;

@end
