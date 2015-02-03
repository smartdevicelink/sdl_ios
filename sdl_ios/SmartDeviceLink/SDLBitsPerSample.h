//  SDLBitsPerSample.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLBitsPerSample : SDLEnum {}

+(SDLBitsPerSample*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLBitsPerSample*) _8_BIT;
+(SDLBitsPerSample*) _16_BIT;

@end
