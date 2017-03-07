#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogConfiguration.h"
#import "SDLLogManager.h"

#import "TestLogTarget.h"

QuickSpecBegin(SDLLogManagerSpec)

describe(@"a log manager", ^{
    __block SDLLogManager *testManager = [SDLLogManager sharedManager];

    describe(@"when initializing", ^{
        expect(testManager.logModules).toNot(beNil());
        expect(testManager.logTargets).toNot(beNil());
        expect(testManager.logFilters).toNot(beNil());
        expect(@(testManager.asynchronous)).to(beFalsy());
        expect(@(testManager.errorsAsynchronous)).to(beFalsy());
        expect(@(testManager.globalLogLevel)).to(equal(@(SDLLogLevelError)));
    });

    describe(@"setting a configuration", ^{
        it(@"should properly set the configuration", ^{
            SDLLogConfiguration *testConfiguration = [SDLLogConfiguration debugConfiguration];
            testConfiguration.logTargets = [NSSet setWithObject:[TestLogTarget logger]];

            expect(testConfiguration.logModules)
        });
    });
});

QuickSpecEnd
