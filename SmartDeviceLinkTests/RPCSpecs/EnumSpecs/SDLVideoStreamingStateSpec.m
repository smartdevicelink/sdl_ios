#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVideoStreamingState.h"

QuickSpecBegin(SDLVideoStreamingStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLVideoStreamingStateStreamable).to(equal(@"STREAMABLE"));
        expect(SDLVideoStreamingStateNotStreamable).to(equal(@"NOT_STREAMABLE"));
    });
});

QuickSpecEnd
