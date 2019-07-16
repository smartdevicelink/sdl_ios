//
//  SDLCreateWindowResponse.m
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 11.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCreateWindowResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLCreateWindowResponse


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCreateWindow]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end
