//  SDLImageFieldName.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLImageFieldName : SDLEnum {}

+(SDLImageFieldName*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLImageFieldName*) softButtonImage;
+(SDLImageFieldName*) choiceImage;
+(SDLImageFieldName*) choiceSecondaryImage;
+(SDLImageFieldName*) vrHelpItem;
+(SDLImageFieldName*) turnIcon;
+(SDLImageFieldName*) menuIcon;
+(SDLImageFieldName*) cmdIcon;
+(SDLImageFieldName*) appIcon;
+(SDLImageFieldName*) graphic;
+(SDLImageFieldName*) showConstantTBTIcon;
+(SDLImageFieldName*) showConstantTBTNextTurnIcon;

@end
