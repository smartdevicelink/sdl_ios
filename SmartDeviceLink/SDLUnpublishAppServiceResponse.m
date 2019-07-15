//
//  SDLUnpublishAppServiceResponse.m
//  SmartDeviceLink
//
//  Created by Bretty White on 7/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLUnpublishAppServiceResponse.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnpublishAppServiceResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnpublishAppService]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
