//  SDLKeypressMode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLKeypressMode : SDLEnum {}

+(SDLKeypressMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLKeypressMode*) SINGLE_KEYPRESS;
+(SDLKeypressMode*) QUEUE_KEYPRESSES;
+(SDLKeypressMode*) RESEND_CURRENT_ENTRY;

@end
