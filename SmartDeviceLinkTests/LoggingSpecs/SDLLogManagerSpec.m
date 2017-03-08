#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogConfiguration.h"
#import "SDLLogFileModule.h"
#import "SDLLogFilter.h"
#import "SDLLogManager.h"
#import "SDLLogModel.h"

#import "TestLogTarget.h"

QuickSpecBegin(SDLLogManagerSpec)

describe(@"a log manager", ^{
    __block SDLLogManager *testManager = nil;

    describe(@"when initializing", ^{
        beforeEach(^{
            testManager = [[SDLLogManager alloc] init];
        });

        expect(testManager.logModules).toNot(beNil());
        expect(testManager.logTargets).toNot(beNil());
        expect(testManager.logFilters).toNot(beNil());
        expect(@(testManager.asynchronous)).to(beFalsy());
        expect(@(testManager.errorsAsynchronous)).to(beFalsy());
        expect(@(testManager.globalLogLevel)).to(equal(@(SDLLogLevelError)));
        expect(@(testManager.formatType)).to(equal(@(SDLLogFormatTypeDefault)));
    });

    describe(@"after setting a configuration", ^{
        __block SDLLogConfiguration *testConfiguration = nil;
        __block TestLogTarget *testLogTarget = nil;

        beforeEach(^{
            testManager = [[SDLLogManager alloc] init];
            testLogTarget = [TestLogTarget logger];

            testConfiguration = [SDLLogConfiguration debugConfiguration];
            testConfiguration.logModules = [NSSet setWithObject:[SDLLogFileModule moduleWithName:@"test" files:[NSSet setWithObject:@"test"]]];
            testConfiguration.logFilters = [NSSet setWithObject:[SDLLogFilter filterByAllowingString:@"test" caseSensitive:NO]];
            testConfiguration.logTargets = [NSSet setWithObject:testLogTarget];
            testConfiguration.logTargets = [NSSet setWithObject:[TestLogTarget logger]];

            [testManager setConfiguration:testConfiguration];
        });

        it(@"should properly set the configuration", ^{
            expect(testManager.logModules).to(equal(testConfiguration.logModules));
            expect(testManager.logFilters).to(equal(testConfiguration.logFilters));
            expect(testManager.logTargets).to(equal(testConfiguration.logTargets));
            expect(@(testManager.asynchronous)).to(equal(@(testConfiguration.asynchronous)));
            expect(@(testManager.errorsAsynchronous)).to(equal(@(testConfiguration.errorsAsynchronous)));
            expect(@(testManager.globalLogLevel)).to(equal(@(SDLLogLevelDebug)));
            expect(@(testManager.formatType)).to(equal(@(SDLLogFormatTypeDetailed)));
        });

        it(@"should properly log a message to log targets", ^{
            SDLLogLevel testLogLevel = SDLLogLevelDebug;
            NSString *testFileName = @"File name";
            NSString *testFunctionName = @"Function name";
            NSInteger testLine = 123;
            NSString *testMessage = @"test message";
            NSString *testQueue = @"test queue";
            [testManager logWithLevel:testLogLevel file:testFileName functionName:testFunctionName line:testLine queue:testQueue message:testMessage];

            expect(testLogTarget.loggedMessages.firstObject.message).to(equal(testMessage));
        });
    });
});

QuickSpecEnd
