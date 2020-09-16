//
//  SDLPerformAppServiceInteractionResponse.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLPerformAppServiceInteractionResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformAppServiceInteractionResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePerformAppServiceInteraction]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithServiceSpecificResult:(NSString *)serviceSpecificResult {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceSpecificResult = serviceSpecificResult;

    return self;
}

- (void)setServiceSpecificResult:(nullable NSString *)serviceSpecificResult {
    [self.parameters sdl_setObject:serviceSpecificResult forName:SDLRPCParameterNameServiceSpecificResult];
}

- (nullable NSString *)serviceSpecificResult {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameServiceSpecificResult ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
