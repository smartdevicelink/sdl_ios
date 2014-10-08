//  SDLButtonName.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLButtonName : SDLEnum {}

+(SDLButtonName*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLButtonName*) OK;
+(SDLButtonName*) SEEKLEFT;
+(SDLButtonName*) SEEKRIGHT;
+(SDLButtonName*) TUNEUP;
+(SDLButtonName*) TUNEDOWN;
+(SDLButtonName*) PRESET_0;
+(SDLButtonName*) PRESET_1;
+(SDLButtonName*) PRESET_2;
+(SDLButtonName*) PRESET_3;
+(SDLButtonName*) PRESET_4;
+(SDLButtonName*) PRESET_5;
+(SDLButtonName*) PRESET_6;
+(SDLButtonName*) PRESET_7;
+(SDLButtonName*) PRESET_8;
+(SDLButtonName*) PRESET_9;
+(SDLButtonName*) CUSTOM_BUTTON;
+(SDLButtonName*) SEARCH;

@end
