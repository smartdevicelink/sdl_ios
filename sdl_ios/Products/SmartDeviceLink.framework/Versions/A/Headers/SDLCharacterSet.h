//  SDLCharacterSet.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLCharacterSet : SDLEnum {}

+(SDLCharacterSet*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLCharacterSet*) TYPE2SET;
+(SDLCharacterSet*) TYPE5SET;
+(SDLCharacterSet*) CID1SET;
+(SDLCharacterSet*) CID2SET;

@end
