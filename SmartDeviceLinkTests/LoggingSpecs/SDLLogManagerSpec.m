#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogConfiguration.h"
#import "SDLLogFileModule.h"
#import "SDLLogFilter.h"
#import "SDLLogManager.h"
#import "SDLLogModel.h"

#import "TestLogTarget.h"

QuickSpecBegin(SDLLogManagerSpec)

fdescribe(@"a log manager", ^{
    __block SDLLogManager *testManager = nil;

    describe(@"when initializing", ^{
        beforeEach(^{
            testManager = [[SDLLogManager alloc] init];
        });

        it(@"should properly initialize properties", ^{
            expect(testManager.modules).toNot(beNil());
            expect(testManager.targets).toNot(beNil());
            expect(testManager.filters).toNot(beNil());
            expect(@(testManager.asynchronous)).to(beTruthy());
            expect(@(testManager.errorsAsynchronous)).to(beFalsy());
            expect(@(testManager.globalLogLevel)).to(equal(@(SDLLogLevelError)));
            expect(@(testManager.formatType)).to(equal(@(SDLLogFormatTypeDefault)));
        });
    });

    describe(@"after setting a configuration", ^{
        __block SDLLogConfiguration *testConfiguration = nil;
        __block TestLogTarget *testLogTarget = nil;

        beforeEach(^{
            testManager = [[SDLLogManager alloc] init];
            testLogTarget = [TestLogTarget logger];

            testConfiguration = [SDLLogConfiguration debugConfiguration];
            testConfiguration.modules = [NSSet setWithObject:[SDLLogFileModule moduleWithName:@"test" files:[NSSet setWithObject:@"test"]]];
            testConfiguration.filters = [NSSet setWithObject:[SDLLogFilter filterByAllowingString:@"test" caseSensitive:NO]];
            testConfiguration.targets = [NSSet setWithObject:testLogTarget];
            testConfiguration.asynchronous = NO;

            [testManager setConfiguration:testConfiguration];
        });

        it(@"should properly set the configuration", ^{
            expect(testManager.modules).to(equal(testConfiguration.modules));
            expect(testManager.filters).to(equal(testConfiguration.filters));
            expect(testManager.targets).to(equal(testConfiguration.targets));
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

        context(@"a simple formatted log", ^{
            beforeEach(^{
                testConfiguration.formatType = SDLLogFormatTypeSimple;
                [testManager setConfiguration:testConfiguration];
            });

            it(@"should properly log the formatted message", ^{
                expect(testLogTarget.formattedLogMessages.firstObject).to(match(@" "));
            });
        });

        context(@"a default formatted log", ^{
            beforeEach(^{
                testConfiguration.formatType = SDLLogFormatTypeDefault;
                [testManager setConfiguration:testConfiguration];
            });

            it(@"should properly log the formatted message", ^{
                expect(testLogTarget.formattedLogMessages.firstObject).to(match(@" "));
            });
        });

        context(@"a detailed formatted log", ^{
            beforeEach(^{
                testConfiguration.formatType = SDLLogFormatTypeDetailed;
                [testManager setConfiguration:testConfiguration];
            });

            it(@"should properly log the formatted message", ^{
                expect(testLogTarget.formattedLogMessages.firstObject).to(match(@" "));
            });
        });
    });
});

QuickSpecEnd
