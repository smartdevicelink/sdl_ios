//
//  SDLTransmissionTypeSpec.m
//  SmartDeviceLinkTests
//

#import <Nimble/Nimble.h>
#import <Quick/Quick.h>
#import "SDLTransmissionType.h"

QuickSpecBegin(SDLTransmissionTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTransmissionTypeAutomatic).to(equal(@"AUTOMATIC"));
        expect(SDLTransmissionTypeContinuouslyVariable).to(equal(@"CONTINUOUSLY_VARIABLE"));
        expect(SDLTransmissionTypeDirectDrive).to(equal(@"DIRECT_DRIVE"));
        expect(SDLTransmissionTypeDualClutch).to(equal(@"DUAL_CLUTCH"));
        expect(SDLTransmissionTypeElectricVariable).to(equal(@"ELECTRIC_VARIABLE"));
        expect(SDLTransmissionTypeInfinitelyVariable).to(equal(@"INFINITELY_VARIABLE"));
        expect(SDLTransmissionTypeManual).to(equal(@"MANUAL"));
        expect(SDLTransmissionTypeSemiAutomatic).to(equal(@"SEMI_AUTOMATIC"));
    });
});

QuickSpecEnd
