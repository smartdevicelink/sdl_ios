//  SDLVrCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLVrCapabilities : SDLEnum {}

+(SDLVrCapabilities*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLVrCapabilities*) TEXT;

@end
