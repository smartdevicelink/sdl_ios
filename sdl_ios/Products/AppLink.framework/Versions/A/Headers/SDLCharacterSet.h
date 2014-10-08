//  SDLCharacterSet.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLCharacterSet : SDLEnum {}

+(SDLCharacterSet*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLCharacterSet*) TYPE2SET;
+(SDLCharacterSet*) TYPE5SET;
+(SDLCharacterSet*) CID1SET;
+(SDLCharacterSet*) CID2SET;

@end
