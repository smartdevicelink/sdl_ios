//  SDLButtonEventMode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLButtonEventMode : SDLEnum {}

+(SDLButtonEventMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLButtonEventMode*) BUTTONUP;
+(SDLButtonEventMode*) BUTTONDOWN;

@end
