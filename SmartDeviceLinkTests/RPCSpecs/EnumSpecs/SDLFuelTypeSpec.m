//
//  SDLFuelTypeSpec.m
//  SmartDeviceLink-iOS
//

//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
