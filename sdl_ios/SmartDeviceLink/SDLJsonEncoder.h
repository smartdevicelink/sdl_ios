//  SDLJsonEncoder.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

@import Foundation;

#import "SDLEncoder.h"

@interface SDLJsonEncoder : NSObject<SDLEncoder> {}

+(NSObject<SDLEncoder>*) instance;

@end
