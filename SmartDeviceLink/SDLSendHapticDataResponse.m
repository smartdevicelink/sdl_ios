
//
//  SDLSendHapticDataResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/4/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSendHapticDataResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendHapticDataResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSendHapticData]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
