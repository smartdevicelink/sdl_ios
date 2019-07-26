//
//  SDLGetInteriorVehicleDataConsentResponse.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetInteriorVehicleDataConsentResponse.h"
#import "SDLRPCFunctionNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLGetInteriorVehicleDataConsentResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetInteriorVehicleDataConsent]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setAllowed:(NSArray<NSNumber<SDLBool> *> *)allowed {
    [self.parameters sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (NSArray<NSNumber<SDLBool> *> *)allowed {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameAllowed ofClass:NSNumber.class error:&error];
}

@end
