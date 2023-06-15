@import Quick;
@import Nimble;

#import "SDLMenuConfiguration.h"

QuickSpecBegin(SDLMenuConfigurationSpec)

describe(@"a menu configuration", ^{
    __block SDLMenuConfiguration *testConfiguration = nil;

    describe(@"initializing", ^{
        it(@"should initialize properly with no variables", ^{
            testConfiguration = [[SDLMenuConfiguration alloc] init];

            expect(testConfiguration.mainMenuLayout).to(equal(SDLMenuLayoutList));
            expect(testConfiguration.defaultSubmenuLayout).to(equal(SDLMenuLayoutList));
        });

        it(@"should initialize properly when set", ^{
            testConfiguration = [[SDLMenuConfiguration alloc] initWithMainMenuLayout:SDLMenuLayoutTiles defaultSubmenuLayout:SDLMenuLayoutTiles];

            expect(testConfiguration.mainMenuLayout).to(equal(SDLMenuLayoutTiles));
            expect(testConfiguration.defaultSubmenuLayout).to(equal(SDLMenuLayoutTiles));
        });
    });
});

QuickSpecEnd
