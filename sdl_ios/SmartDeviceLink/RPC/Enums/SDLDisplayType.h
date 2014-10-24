//  SDLDisplayType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLDisplayType : SDLEnum {}

+(SDLDisplayType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLDisplayType*) CID;
+(SDLDisplayType*) TYPE2;
+(SDLDisplayType*) TYPE5;
+(SDLDisplayType*) NGN;
+(SDLDisplayType*) GEN2_8_DMA;
+(SDLDisplayType*) GEN2_6_DMA;
+(SDLDisplayType*) MFD3;
+(SDLDisplayType*) MFD4;
+(SDLDisplayType*) MFD5;
+(SDLDisplayType*) GEN3_8_INCH;

@end
