//
//  SDLFuelTypeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLFuelType.h"

QuickSpecBegin(SDLFuelTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLFuelTypeGasoline).to(equal(@"GASOLINE"));
        expect(SDLFuelTypeDiesel).to(equal(@"DIESEL"));
        expect(SDLFuelTypeCNG).to(equal(@"CNG"));
        expect(SDLFuelTypeLPG).to(equal(@"LPG"));
        expect(SDLFuelTypeHydrogen).to(equal(@"HYDROGEN"));
        expect(SDLFuelTypeBattery).to(equal(@"BATTERY"));
    });
});

QuickSpecEnd
