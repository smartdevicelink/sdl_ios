//  SDLSlider.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

@interface SDLSlider : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* numTicks;
@property(strong) NSNumber* position;
@property(strong) NSString* sliderHeader;
@property(strong) NSMutableArray* sliderFooter;
@property(strong) NSNumber* timeout;

@end
