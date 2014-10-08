//  SDLDecoder.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

@protocol SDLDecoder

-(NSDictionary*) decode:(NSData*) msgBytes;

@end
