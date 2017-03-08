#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogTargetASL.h"
#import "SDLLogConfiguration.h"

QuickSpecBegin(SDLLogConfigurationSpec)

describe(@"a log configuration", ^{
    __block SDLLogConfiguration *testConfiguration = nil;

    describe(@"a default configuration", ^{
        it(@"should properly set default properties", ^{
            testConfiguration = [SDLLogConfiguration defaultConfiguration];

            expect(testConfiguration.modules).toNot(beEmpty());
            expect(testConfiguration.filters).to(beEmpty());
            expect(@(testConfiguration.targets.count)).to(equal(@1));
            expect([testConfiguration.targets anyObject].class).to(equal([SDLLogTargetASL class]));
            expect(@(testConfiguration.formatType)).to(equal(@(SDLLogFormatTypeDefault)));
            expect(@(testConfiguration.asynchronous)).to(equal(@YES));
            expect(@(testConfiguration.errorsAsynchronous)).to(equal(@NO));
            expect(@(testConfiguration.globalLogLevel)).to(equal(@(SDLLogLevelError)));
        });
    });

    describe(@"a debug configuration", ^{
        it(@"should properly set debug properties", ^{
            testConfiguration = [SDLLogConfiguration debugConfiguration];

            expect(testConfiguration.modules).toNot(beEmpty());
            expect(testConfiguration.filters).to(beEmpty());
            expect(@(testConfiguration.targets.count)).to(equal(@1));
            expect([testConfiguration.targets anyObject].class).to(equal([SDLLogTargetASL class]));
            expect(@(testConfiguration.formatType)).to(equal(@(SDLLogFormatTypeDetailed)));
            expect(@(testConfiguration.asynchronous)).to(equal(@YES));
            expect(@(testConfiguration.errorsAsynchronous)).to(equal(@NO));
            expect(@(testConfiguration.globalLogLevel)).to(equal(@(SDLLogLevelDebug)));
        });
    });
});

QuickSpecEnd
