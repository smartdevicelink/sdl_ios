
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemCapabilityType.h"

QuickSpecBegin(SDLSystemCapabilityTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSystemCapabilityTypeAppServices).to(equal(@"APP_SERVICES"));
        expect(SDLSystemCapabilityTypeNavigation).to(equal(@"NAVIGATION"));
        expect(SDLSystemCapabilityTypePhoneCall).to(equal(@"PHONE_CALL"));
        expect(SDLSystemCapabilityTypeVideoStreaming).to(equal(@"VIDEO_STREAMING"));
        expect(SDLSystemCapabilityTypeRemoteControl).to(equal(@"REMOTE_CONTROL"));
        expect(SDLSystemCapabilityTypeDisplays).to(equal(@"DISPLAYS"));
        expect(SDLSystemCapabilityTypeSeatLocation).to(equal(@"SEAT_LOCATION"));
        expect(SDLSystemCapabilityTypeDriverDistraction).to(equal(@"DRIVER_DISTRACTION"));
    });
});

QuickSpecEnd
