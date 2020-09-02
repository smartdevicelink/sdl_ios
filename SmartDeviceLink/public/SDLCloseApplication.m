//
//  SDLCloseApplication.m
//  SmartDeviceLink
//
//  Created by Nicole on 7/9/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCloseApplication.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLCloseApplication

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCloseApplication]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
