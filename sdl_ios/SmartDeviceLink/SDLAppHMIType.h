//  SDLAppHMIType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLAppHMIType : SDLEnum {}

+(SDLAppHMIType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLAppHMIType*) DEFAULT;
+(SDLAppHMIType*) COMMUNICATION;
+(SDLAppHMIType*) MEDIA;
+(SDLAppHMIType*) MESSAGING;
+(SDLAppHMIType*) NAVIGATION;
+(SDLAppHMIType*) INFORMATION;
+(SDLAppHMIType*) SOCIAL;
+(SDLAppHMIType*) BACKGROUND_PROCESS;
+(SDLAppHMIType*) TESTING;
+(SDLAppHMIType*) SYSTEM;

@end
