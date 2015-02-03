//  SDLSamplingRate.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLSamplingRate : SDLEnum {}

+(SDLSamplingRate*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLSamplingRate*) _8KHZ;
+(SDLSamplingRate*) _16KHZ;
+(SDLSamplingRate*) _22KHZ;
+(SDLSamplingRate*) _44KHZ;

@end
