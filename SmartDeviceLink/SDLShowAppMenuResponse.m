//
//  SDLOpenMenuResponse.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLShowAppMenuResponse.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLShowAppMenuResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
        if (self = [super initWithName:SDLRPCFunctionNameShowAppMenu]) {
        }
        return self;
}
#pragma clang diagnostic pop

@end
