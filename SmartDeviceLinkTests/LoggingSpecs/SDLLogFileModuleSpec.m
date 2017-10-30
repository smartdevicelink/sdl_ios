#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogFileModule.h"

QuickSpecBegin(SDLLogFileModuleSpec)

describe(@"a file module", ^{
    __block NSString *testModuleName = @"Test Name";
    __block NSSet<NSString *> *testFiles = nil;
    __block NSString *testFileName = @"Test File Name";
    __block SDLLogLevel testLogLevel = SDLLogLevelDebug;

    beforeEach(^{
        testFiles = [NSSet setWithObject:testFileName];
    });

    describe(@"initialized with initWithName:files:level:", ^{
        __block SDLLogFileModule *testModule = nil;
        beforeEach(^{
            testModule = [[SDLLogFileModule alloc] initWithName:testModuleName files:testFiles level:testLogLevel];
        });

        it(@"should properly initialize properties", ^{
            expect(testModule.name).to(match(testModuleName));
            expect(testModule.files).to(equal(testFiles));
            expect(@(testModule.logLevel)).to(equal(@(testLogLevel)));
        });

        it(@"should contain the file", ^{
            BOOL shouldContainFile = [testModule containsFile:testFileName];
            BOOL shouldNotContainFile = [testModule containsFile:@"not a file"];
            expect(@(shouldContainFile)).to(equal(@YES));
            expect(@(shouldNotContainFile)).to(equal(@NO));
        });
    });

    describe(@"initialized with initWithName:files:", ^{
        __block SDLLogFileModule *testModule = nil;

        it(@"should properly initialize properties", ^{
            testModule = [[SDLLogFileModule alloc] initWithName:testModuleName files:testFiles];
            expect(testModule.name).to(match(testModuleName));
            expect(testModule.files).to(equal(testFiles));
            expect(@(testModule.logLevel)).to(equal(@(SDLLogLevelDefault)));
        });

        it(@"should properly initialize properties", ^{
            testModule = [SDLLogFileModule moduleWithName:testModuleName files:testFiles];
            expect(testModule.name).to(match(testModuleName));
            expect(testModule.files).to(equal(testFiles));
            expect(@(testModule.logLevel)).to(equal(@(SDLLogLevelDefault)));
        });
    });
});

QuickSpecEnd
