//  SDLDriverDistractionState.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLDriverDistractionState : SDLEnum {}

+(SDLDriverDistractionState*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLDriverDistractionState*) DD_ON;
+(SDLDriverDistractionState*) DD_OFF;

@end
