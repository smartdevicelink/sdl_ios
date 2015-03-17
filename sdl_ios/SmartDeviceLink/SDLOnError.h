//
//  SDLOnError.h
//  SmartDeviceLink
//
//  Created by Militello, Kevin (K.) on 12/17/14.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink/SDLInternalProxyMessage.h"

@interface SDLOnError : SDLInternalProxyMessage

-(instancetype)initWithError:(NSError*)error;

@property (strong, nonatomic) NSString* info;
@property (strong, nonatomic) NSError* error;

@end
