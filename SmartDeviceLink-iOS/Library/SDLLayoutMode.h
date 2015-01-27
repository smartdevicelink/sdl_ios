//  SDLLayoutMode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLLayoutMode : SDLEnum {}

+(SDLLayoutMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLLayoutMode*) ICON_ONLY;
+(SDLLayoutMode*) ICON_WITH_SEARCH;
+(SDLLayoutMode*) LIST_ONLY;
+(SDLLayoutMode*) LIST_WITH_SEARCH;
+(SDLLayoutMode*) KEYBOARD;

@end
