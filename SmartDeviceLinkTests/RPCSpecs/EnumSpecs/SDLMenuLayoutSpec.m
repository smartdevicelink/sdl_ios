@import Quick;
@import Nimble;

#import "SDLMenuLayout.h"

QuickSpecBegin(SDLMenuLayoutSpec)

describe(@"Individual Enum Value Tests", ^{
    it(@"Should match internal values", ^{
        expect(SDLMenuLayoutList).to(equal(@"LIST"));
        expect(SDLMenuLayoutTiles).to(equal(@"TILES"));
    });
});

QuickSpecEnd
