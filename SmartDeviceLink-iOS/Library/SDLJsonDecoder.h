//  SDLJsonDecoder.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

@import Foundation;

#import "SDLDecoder.h"

@interface SDLJsonDecoder : NSObject<SDLDecoder> {}

+(NSObject<SDLDecoder>*) instance;

@end
