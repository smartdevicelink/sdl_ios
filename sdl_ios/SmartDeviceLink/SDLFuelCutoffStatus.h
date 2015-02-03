//  SDLFuelCutoffStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLFuelCutoffStatus : SDLEnum {}

+(SDLFuelCutoffStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLFuelCutoffStatus*) TERMINATE_FUEL;
+(SDLFuelCutoffStatus*) NORMAL_OPERATION;
+(SDLFuelCutoffStatus*) FAULT;

@end
