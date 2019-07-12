//
//  SDLCancelInteraction.m
//  SmartDeviceLink
//
//  Created by Nicole on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCancelInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLCancelInteraction

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCancelInteraction]) {
    }
    return self;
}
#pragma clang diagnostic pop


- (instancetype)initWithfunctionID:(UInt32)functionID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.functionID = @(functionID);

    return self;
}

- (instancetype)initWithfunctionID:(UInt32)functionID cancelID:(UInt32)cancelID {
    self = [self initWithfunctionID:functionID];
    if (!self) {
        return nil;
    }

    self.cancelID = @(cancelID);

    return self;
}

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

- (void)setFunctionID:(NSNumber<SDLInt> *)functionID {
    [self.parameters sdl_setObject:functionID forName:SDLRPCParameterNameFunctionID];
}

- (NSNumber<SDLInt> *)functionID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFunctionID ofClass:NSNumber.class error:&error];
}


@end

NS_ASSUME_NONNULL_END
