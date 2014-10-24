//  SDLImageType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLImageType : SDLEnum {}

+(SDLImageType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLImageType*) STATIC;
+(SDLImageType*) DYNAMIC;

@end
