//
//  SDLRadioStateSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRadioState.h"

QuickSpecBegin(SDLRadioStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLRadioBandAcquiring).to(equal(@"ACQUIRING"));
        expect(SDLRadioStateAcquired).to(equal(@"ACQUIRED"));
        expect(SDLRadioStateMulticast).to(equal(@"MULTICAST"));
        expect(SDLRadioStateNotFound).to(equal(@"NOT_FOUND"));
    });
});

QuickSpecEnd
