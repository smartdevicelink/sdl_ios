//  SDLDeliverModeSpec.m
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDeliveryMode.h"

QuickSpecBegin(SDLDeliveryModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDeliveryModePrompt).to(equal(@"PROMPT"));
        expect(SDLDeliveryModeDestination).to(equal(@"DESTINATION"));
        expect(SDLDeliveryModeQueue).to(equal(@"QUEUE"));
    });
});

QuickSpecEnd
