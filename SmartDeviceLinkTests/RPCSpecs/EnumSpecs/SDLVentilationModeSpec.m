//
//  SDLVentilationModeSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVentilationMode.h"

QuickSpecBegin(SDLVentilationModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLVentilationModeUpper).to(equal(@"UPPER"));
        expect(SDLVentilationModeLower).to(equal(@"LOWER"));
        expect(SDLVentilationModeBoth).to(equal(@"BOTH"));
        expect(SDLVentilationModeNorth).to(equal(@"NONE"));
    });
});

QuickSpecEnd
