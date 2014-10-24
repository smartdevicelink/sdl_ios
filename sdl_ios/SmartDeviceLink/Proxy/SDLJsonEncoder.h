//  SDLJsonEncoder.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEncoder.h>

@interface SDLJsonEncoder : NSObject<SDLEncoder> {}

+(NSObject<SDLEncoder>*) instance;

@end
