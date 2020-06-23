//
//  SDLTransmissionTypeSpec.m
//  SmartDeviceLinkTests
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLTransmissionType.h"

QuickSpecBegin(SDLTransmissionTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTransmissionTypeManual).to(equal(@"MANUAL"));
        expect(SDLTransmissionTypeAutomatic).to(equal(@"AUTOMATIC"));
        expect(SDLTransmissionTypeSemiAutomatic).to(equal(@"SEMI_AUTOMATIC"));
        expect(SDLTransmissionTypeDualClutch).to(equal(@"DUAL_CLUTCH"));
        expect(SDLTransmissionTypeContinuouslyVariable).to(equal(@"CONTINUOUSLY_VARIABLE"));
        expect(SDLTransmissionTypeInfinitelyVariable).to(equal(@"INFINITELY_VARIABLE"));
        expect(SDLTransmissionTypeElectricVariable).to(equal(@"ELECTRIC_VARIABLE"));
        expect(SDLTransmissionTypeDirectDrive).to(equal(@"DIRECT_DRIVE"));
    });
});

QuickSpecEnd
