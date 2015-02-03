//  SDLComponentVolumeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLComponentVolumeStatus : SDLEnum {}

+(SDLComponentVolumeStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLComponentVolumeStatus*) UNKNOWN;
+(SDLComponentVolumeStatus*) NORMAL;
+(SDLComponentVolumeStatus*) LOW;
+(SDLComponentVolumeStatus*) FAULT;
+(SDLComponentVolumeStatus*) ALERT;
+(SDLComponentVolumeStatus*) NOT_SUPPORTED;

@end
