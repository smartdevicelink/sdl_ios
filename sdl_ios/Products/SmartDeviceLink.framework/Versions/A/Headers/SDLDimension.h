//  SDLDimension.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLDimension : SDLEnum {}

+(SDLDimension*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLDimension*) NO_FIX;
+(SDLDimension*) _2D;
+(SDLDimension*) _3D;

@end
