#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogModel.h"

QuickSpecBegin(SDLLogModelSpec)

describe(@"a log model", ^{
    __block SDLLogModel *testModel = nil;

    it(@"should initialize correctly", ^{
        NSString *testMessage = @"test message";
        NSDate *testTimestamp = [NSDate date];
        SDLLogLevel testLogLevel = SDLLogLevelDebug;
        NSString *testFileName = @"test file name";
        NSString *testModuleName = @"test module name";
        NSString *testFunctionName = @"test function name";
        NSInteger testLine = 123;
        NSString *testQueue = @"test queue label";
        testModel = [[SDLLogModel alloc] initWithMessage:testMessage timestamp:testTimestamp level:testLogLevel fileName:testFileName moduleName:testModuleName functionName:testFunctionName line:testLine queueLabel:testQueue];

        expect(testModel.message).to(match(testMessage));
        expect(testModel.timestamp).to(equal(testTimestamp));
        expect(@(testModel.level)).to(equal(@(testLogLevel)));
        expect(testModel.fileName).to(match(testFileName));
        expect(testModel.moduleName).to(match(testModuleName));
        expect(testModel.functionName).to(match(testFunctionName));
        expect(@(testModel.line)).to(equal(@(testLine)));
        expect(testModel.queueLabel).to(match(testQueue));
    });
});

QuickSpecEnd
