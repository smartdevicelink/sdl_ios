//  SDLIgnitionStableStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLIgnitionStableStatus : SDLEnum {}

+(SDLIgnitionStableStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLIgnitionStableStatus*) IGNITION_SWITCH_NOT_STABLE;
+(SDLIgnitionStableStatus*) IGNITION_SWITCH_STABLE;
+(SDLIgnitionStableStatus*) MISSING_FROM_TRANSMITTER;

@end
