
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemCapabilityType.h"

QuickSpecBegin(SDLSystemCapabilityTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSystemCapabilityTypeNavigation).to(equal(@"NAVIGATION"));
        expect(SDLSystemCapabilityTypePhoneCall).to(equal(@"PHONE_CALL"));
    });
});

QuickSpecEnd
