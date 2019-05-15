#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLMenuRunScore.h"

QuickSpecBegin(SDLMenuRunScoreSpec)

describe(@"menuRunScore", ^{
    __block SDLMenuRunScore *runScore = nil;

    beforeEach(^{
        NSArray<NSNumber *> *oldMenuStatus = @[@1, @2, @3];
        NSArray<NSNumber *> *updatedMenuStatus = @[@3, @2, @1];
        NSUInteger numberOfAdds = 5;

        runScore = [[SDLMenuRunScore alloc] initWithOldStatus:oldMenuStatus updatedStatus:updatedMenuStatus score:numberOfAdds];
    });

    it(@"should instantiate correctly", ^{
        expect(runScore.oldStatus).to(equal(@[@1, @2, @3]));
        expect(runScore.updatedStatus).to(equal(@[@3, @2, @1]));
        expect(runScore.score).to(equal(5));
    });
});

QuickSpecEnd
