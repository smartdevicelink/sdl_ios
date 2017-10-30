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
    __block NSDate *testDate = [NSDate date];
    __block NSString *formattedDate = [[SDLLogManager dateFormatter] stringFromDate:testDate];

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
            testConfiguration.filters = [NSSet setWithObject:[SDLLogFilter filterByDisallowingString:@"this string should never trigger" caseSensitive:NO]];
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
            [testManager logWithLevel:testLogLevel timestamp:testDate file:testFileName functionName:testFunctionName line:testLine queue:testQueue message:testMessage];

            expect(testLogTarget.loggedMessages.firstObject.message).to(equal(testMessage));
        });

        describe(@"logging a formatted log string", ^{
            __block SDLLogLevel testLogLevel = SDLLogLevelDebug;
            __block NSString *testFileName = @"file";
            __block NSString *testFunctionName = @"function";
            __block NSInteger testLine = 123;
            __block NSString *testMessage = @"message";
            __block NSString *testQueue = @"queue";

            context(@"simple format", ^{
                it(@"should properly log the formatted message", ^{
                    testConfiguration.formatType = SDLLogFormatTypeSimple;
                    [testManager setConfiguration:testConfiguration];
                    [testManager logWithLevel:testLogLevel timestamp:testDate file:testFileName functionName:testFunctionName line:testLine queue:testQueue message:testMessage];

                    NSString *formattedLog = [NSString stringWithFormat:@"%@ 🔵 (SDL)- %@", formattedDate, testMessage];
                    expect(testLogTarget.formattedLogMessages.firstObject).to(contain(formattedLog));
                });
            });

            context(@"default format", ^{
                it(@"should properly log the formatted message", ^{
                    testConfiguration.formatType = SDLLogFormatTypeDefault;
                    [testManager setConfiguration:testConfiguration];
                    [testManager logWithLevel:testLogLevel timestamp:testDate file:testFileName functionName:testFunctionName line:testLine queue:testQueue message:testMessage];

                    NSString *formattedLog = [NSString stringWithFormat:@"%@ 🔵 (SDL):%@:%ld - %@", formattedDate, testFileName, testLine, testMessage];
                    expect(testLogTarget.formattedLogMessages.firstObject).to(contain(formattedLog));
                });
            });

            context(@"detailed format", ^{
                it(@"should properly log the formatted message", ^{
                    testConfiguration.formatType = SDLLogFormatTypeDetailed;
                    [testManager setConfiguration:testConfiguration];
                    [testManager logWithLevel:testLogLevel timestamp:testDate file:testFileName functionName:testFunctionName line:testLine queue:testQueue message:testMessage];

                    NSString *formattedLog = [NSString stringWithFormat:@"%@ 🔵 DEBUG %@ (SDL):%@:%@:%ld - %@", formattedDate, testQueue, testFileName, testFunctionName, testLine, testMessage];
                    expect(testLogTarget.formattedLogMessages.firstObject).to(contain(formattedLog));
                });
            });
        });

        describe(@"log output", ^{
            __block NSString *testFileName = @"file";
            __block NSString *testFunctionName = @"function";
            __block NSString *testQueue = @"queue";

            __block SDLLogLevel testLogLevelWarning = SDLLogLevelWarning;
            __block SDLLogLevel testLogLevelError = SDLLogLevelError;
            __block SDLLogLevel testLogLevelDebug = SDLLogLevelDebug;
            __block SDLLogLevel testLogLevelVerbose = SDLLogLevelVerbose;

            __block NSInteger testLineWarning;
            __block NSString *testMessageWarning;
            __block NSString *testWarningFormattedLog;
            __block NSInteger testLineError;
            __block NSString *testMessageError;
            __block NSString *testErrorFormattedLog;
            __block NSInteger testLineDebug;
            __block NSString *testMessageDebug;
            __block NSString *testDebugFormattedLog;
            __block NSInteger testLineVerbose;
            __block NSString *testMessageVerbose;
            __block NSString *testVerboseFormattedLog;

            __block int expectedLogCount;
            __block NSMutableArray<NSString *> *expectedMessages;
            __block NSMutableArray<NSString *> *notExpectedMessages;

            context(@"The type of debug messages logged depends on the SDLLogLevel", ^{
                beforeEach(^{
                    testConfiguration = [[SDLLogConfiguration alloc] init];
                    testConfiguration.targets = [NSSet setWithObject:testLogTarget];
                    testConfiguration.asynchronous = NO;
                    testConfiguration.formatType = SDLLogFormatTypeSimple;

                    testLineWarning = 1;
                    testMessageWarning = @"warningMessage";
                    testWarningFormattedLog = [NSString stringWithFormat:@"%@ 🔶 (SDL)- %@", formattedDate, testMessageWarning];

                    testLineError = 2;
                    testMessageError = @"errorMessage";
                    testErrorFormattedLog = [NSString stringWithFormat:@"%@ ❌ (SDL)- %@", formattedDate, testMessageError];

                    testLineDebug = 3;
                    testMessageDebug = @"debugMessage";
                    testDebugFormattedLog = [NSString stringWithFormat:@"%@ 🔵 (SDL)- %@", formattedDate, testMessageDebug];

                    testLineVerbose = 4;
                    testMessageVerbose = @"verboseMessage";
                    testVerboseFormattedLog = [NSString stringWithFormat:@"%@ ⚪ (SDL)- %@", formattedDate, testMessageVerbose];

                    expectedMessages = [[NSMutableArray alloc] init];
                    notExpectedMessages = [[NSMutableArray alloc] init];
                });

                describe(@"When the global log level is set", ^{
                    beforeEach(^{
                        expectedLogCount = 0;
                        expect(testLogTarget.formattedLogMessages.count).to(equal(0));
                        expect(expectedMessages.count).to(equal(0));
                        expect(notExpectedMessages.count).to(equal(0));
                    });

                    it(@"should not log anything when the log level is OFF", ^{
                        testConfiguration.globalLogLevel = SDLLogLevelOff;
                        expectedLogCount = 0;

                        [notExpectedMessages addObject:testWarningFormattedLog];
                        [notExpectedMessages addObject:testErrorFormattedLog];
                        [notExpectedMessages addObject:testDebugFormattedLog];
                        [notExpectedMessages addObject:testVerboseFormattedLog];
                    });

                    it(@"should only log errors when the log level is ERROR", ^{
                        testConfiguration.globalLogLevel = SDLLogLevelError;
                        expectedLogCount = 1;

                        [expectedMessages addObject:testErrorFormattedLog];

                        [notExpectedMessages addObject:testWarningFormattedLog];
                        [notExpectedMessages addObject:testDebugFormattedLog];
                        [notExpectedMessages addObject:testVerboseFormattedLog];
                    });

                    it(@"should only log errors and warnings when the log level is WARNING", ^{
                        testConfiguration.globalLogLevel = SDLLogLevelWarning;
                        expectedLogCount = 2;

                        [expectedMessages addObject:testWarningFormattedLog];
                        [expectedMessages addObject:testErrorFormattedLog];

                        [notExpectedMessages addObject:testDebugFormattedLog];
                        [notExpectedMessages addObject:testVerboseFormattedLog];
                    });

                    it(@"should only log errors, warnings, and debug logs when the log level is DEBUG", ^{
                        testConfiguration.globalLogLevel = SDLLogLevelDebug;
                        expectedLogCount = 3;

                        [expectedMessages addObject:testWarningFormattedLog];
                        [expectedMessages addObject:testErrorFormattedLog];
                        [expectedMessages addObject:testDebugFormattedLog];

                        [notExpectedMessages addObject:testVerboseFormattedLog];
                    });

                    it(@"should log errors, warnings, debug, and verbose logs when the log level is VERBOSE", ^{
                        testConfiguration.globalLogLevel = SDLLogLevelVerbose;
                        expectedLogCount = 4;

                        [expectedMessages addObject:testWarningFormattedLog];
                        [expectedMessages addObject:testErrorFormattedLog];
                        [expectedMessages addObject:testDebugFormattedLog];
                        [expectedMessages addObject:testVerboseFormattedLog];
                    });

                    afterEach(^{
                        [testManager setConfiguration:testConfiguration];

                        // Warning
                        [testManager logWithLevel:testLogLevelWarning timestamp:testDate file:testFileName functionName:testFunctionName line:testLineWarning queue:testQueue message:testMessageWarning];

                        // Error
                        [testManager logWithLevel:testLogLevelError timestamp:testDate file:testFileName functionName:testFunctionName line:testLineError queue:testQueue message:testMessageError];

                        // Debug
                        [testManager logWithLevel:testLogLevelDebug timestamp:testDate file:testFileName functionName:testFunctionName line:testLineDebug queue:testQueue message:testMessageDebug];

                        // Verbose
                        [testManager logWithLevel:testLogLevelVerbose timestamp:testDate file:testFileName functionName:testFunctionName line:testLineVerbose queue:testQueue message:testMessageVerbose];
                    });
                });

                afterEach(^{
                    expect(testManager.asynchronous).to(equal(NO));
                    expect(testLogTarget.formattedLogMessages.count).to(equal(expectedLogCount));

                    for(int i = 0; i < expectedMessages.count; i += 1) {
                        expect([testLogTarget.formattedLogMessages objectAtIndex:i]).to(contain(expectedMessages[i]));
                    }

                    for(int i = 0; i < notExpectedMessages.count; i += 1) {
                        expect(testLogTarget.formattedLogMessages).toNot(contain(notExpectedMessages[i]));
                    }
                });
            });
        });
    });
});



QuickSpecEnd
