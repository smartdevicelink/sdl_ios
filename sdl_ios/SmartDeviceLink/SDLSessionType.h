//
//  SDLSessionType.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLByteEnumer.h>

@interface SDLSessionType : SDLByteEnumer

+(SDLSessionType*)Heartbeat;
+(SDLSessionType*)RPC;
+(SDLSessionType*)PCM;
+(SDLSessionType*)NAV;
+(SDLSessionType*)Bulk_Data;

+(SDLSessionType*)valueOf:(Byte)passedButton;
+(NSArray*)values;

@end
