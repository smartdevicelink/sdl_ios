//
//  SDLTemperatureUnitSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTemperatureUnit.h"

QuickSpecBegin(SDLTemperatureUnitSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTemperatureUnitCelsius).to(equal(@"CELSIUS"));
        expect(SDLTemperatureUnitFahrenheit).to(equal(@"FAHRENHEIT"));
    });
});

QuickSpecEnd
