//  SDLDecoder.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

@import Foundation;

@protocol SDLDecoder

-(NSDictionary*) decode:(NSData*) msgBytes;

@end
