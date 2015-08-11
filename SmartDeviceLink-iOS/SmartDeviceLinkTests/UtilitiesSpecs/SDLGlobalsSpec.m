#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobals.h"

QuickSpecBegin(SDLGlobalsSpec)

describe(@"The SDLGlobals class", ^{
    __block SDLGlobals *testGlobals = nil;
    beforeEach(^{
        testGlobals = [[SDLGlobals alloc] init];
    });
    
    describe(@"when just initialized", ^{
        it(@"should properly set protocol version", ^{
            expect(@(testGlobals.protocolVersion)).to(equal(@1));
        });
        
        it(@"should properly set max head unit version", ^{
            expect(@(testGlobals.maxHeadUnitVersion)).to(equal(@0));
        });
        
        it(@"should throw an exception trying to get max MTU size", ^{
            expect(@(testGlobals.maxMTUSize)).to(equal(@1024));
        });
    });
});

QuickSpecEnd
