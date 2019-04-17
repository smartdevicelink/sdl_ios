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

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePerformAppServiceInteraction]) {
    }
    return self;
}

- (instancetype)initWithServiceSpecificResult:(NSString *)serviceSpecificResult {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceSpecificResult = serviceSpecificResult;

    return self;
}

- (void)setServiceSpecificResult:(nullable NSString *)serviceSpecificResult {
    [parameters sdl_setObject:serviceSpecificResult forName:SDLRPCParameterNameServiceSpecificResult];
}

- (nullable NSString *)serviceSpecificResult {
    return [parameters sdl_objectForName:SDLRPCParameterNameServiceSpecificResult ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
