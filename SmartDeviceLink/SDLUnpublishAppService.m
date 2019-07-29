//
//  SDLUnpublishAppService.m
//  SmartDeviceLink
//
//  Created by Bretty White on 7/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLUnpublishAppService.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnpublishAppService

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnpublishAppService]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithServiceID:(NSString *)serviceID {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.serviceID = serviceID;
    
    return self;
}

- (void)setServiceID:(NSString *)serviceID {
    [self.parameters sdl_setObject:serviceID forName:SDLRPCParameterNameServiceID];
}

- (NSString *)serviceID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameServiceID ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
