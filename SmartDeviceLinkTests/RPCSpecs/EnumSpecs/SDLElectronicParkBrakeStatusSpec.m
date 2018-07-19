#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLElectronicParkBrakeStatus.h"

QuickSpecBegin(SDLElectronicParkBrakeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLElectronicParkBrakeStatusClosed).to(equal(@"CLOSED"));
        expect(SDLElectronicParkBrakeStatusTransition).to(equal(@"TRANSITION"));
        expect(SDLElectronicParkBrakeStatusOpen).to(equal(@"OPEN"));
        expect(SDLElectronicParkBrakeStatusDriveActive).to(equal(@"DRIVE_ACTIVE"));
        expect(SDLElectronicParkBrakeStatusFault).to(equal(@"FAULT"));
    });
});

QuickSpecEnd
