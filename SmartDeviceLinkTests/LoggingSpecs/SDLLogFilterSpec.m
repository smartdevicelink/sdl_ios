#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogFileModule.h"
#import "SDLLogFilter.h"
#import "SDLLogModel.h"


QuickSpecBegin(SDLfilterspec)

describe(@"a filter by a string", ^{
    __block NSString *testFilterString = @"filter string";
    __block SDLLogModel *testFilterModel = [[SDLLogModel alloc] initWithMessage:testFilterString timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    __block NSString *testOtherString = @"Other string";
    __block SDLLogModel *testOtherModel = [[SDLLogModel alloc] initWithMessage:testOtherString timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    __block NSString *testCaseFilterString = @"Filter string";
    __block SDLLogModel *testCaseFilterModel = [[SDLLogModel alloc] initWithMessage:testCaseFilterString timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    context(@"that disallows a string", ^{
        context(@"that is case sensitive", ^{
            SDLLogFilter *testFilter = [SDLLogFilter filterByDisallowingString:testFilterString caseSensitive:YES];

            it(@"should fail a matching string", ^{
                BOOL pass = testFilter.filter(testFilterModel);
                expect(@(pass)).to(equal(@NO));
            });

            it(@"should pass a non-matching string", ^{
                BOOL pass = testFilter.filter(testOtherModel);
                expect(@(pass)).to(equal(@YES));
            });

            it(@"should pass a differently cased string", ^{
                BOOL pass = testFilter.filter(testCaseFilterModel);
                expect(@(pass)).to(equal(@YES));
            });
        });

        context(@"that is case insensitive", ^{
            SDLLogFilter *testFilter = [SDLLogFilter filterByDisallowingString:testFilterString caseSensitive:NO];

            it(@"should fail a matching string", ^{
                BOOL pass = testFilter.filter(testFilterModel);
                expect(@(pass)).to(equal(@NO));
            });

            it(@"should pass a non-matching string", ^{
                BOOL pass = testFilter.filter(testOtherModel);
                expect(@(pass)).to(equal(@YES));
            });

            it(@"should fail a differently cased string", ^{
                BOOL pass = testFilter.filter(testCaseFilterModel);
                expect(@(pass)).to(equal(@NO));
            });
        });
    });

    context(@"that allows a string", ^{
        context(@"that is case sensitive", ^{
            SDLLogFilter *testFilter = [SDLLogFilter filterByAllowingString:testFilterString caseSensitive:YES];

            it(@"should pass a matching string", ^{
                BOOL pass = testFilter.filter(testFilterModel);
                expect(@(pass)).to(equal(@YES));
            });

            it(@"should fail a non-matching string", ^{
                BOOL pass = testFilter.filter(testOtherModel);
                expect(@(pass)).to(equal(@NO));
            });

            it(@"should fail a differently cased string", ^{
                BOOL pass = testFilter.filter(testCaseFilterModel);
                expect(@(pass)).to(equal(@NO));
            });
        });

        context(@"that is case insensitive", ^{
            SDLLogFilter *testFilter = [SDLLogFilter filterByAllowingString:testFilterString caseSensitive:NO];

            it(@"should pass a matching string", ^{
                BOOL pass = testFilter.filter(testFilterModel);
                expect(@(pass)).to(equal(@YES));
            });

            it(@"should fail a non-matching string", ^{
                BOOL pass = testFilter.filter(testOtherModel);
                expect(@(pass)).to(equal(@NO));
            });

            it(@"should pass a differently cased string", ^{
                BOOL pass = testFilter.filter(testCaseFilterModel);
                expect(@(pass)).to(equal(@YES));
            });
        });
    });
});

describe(@"a filter by regex", ^{
    __block NSString *testFilterString = @"filter string";
    __block SDLLogModel *testFilterModel = [[SDLLogModel alloc] initWithMessage:testFilterString timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    __block NSString *testOtherString = @"OTHER STRING";
    __block SDLLogModel *testOtherModel = [[SDLLogModel alloc] initWithMessage:testOtherString timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    context(@"that disallows a regex", ^{
        NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+" options:0 error:nil];
        SDLLogFilter *testFilter = [SDLLogFilter filterByDisallowingRegex:expr];

        it(@"should fail a matching string", ^{
            BOOL pass = testFilter.filter(testFilterModel);
            expect(@(pass)).to(equal(@NO));
        });

        it(@"should pass a non-matching string", ^{
            BOOL pass = testFilter.filter(testOtherModel);
            expect(@(pass)).to(equal(@YES));
        });
    });

    context(@"that allows a regex", ^{
        NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+" options:0 error:nil];
        SDLLogFilter *testFilter = [SDLLogFilter filterByAllowingRegex:expr];

        it(@"should pass a matching string", ^{
            BOOL pass = testFilter.filter(testFilterModel);
            expect(@(pass)).to(equal(@YES));
        });

        it(@"should fail a non-matching string", ^{
            BOOL pass = testFilter.filter(testOtherModel);
            expect(@(pass)).to(equal(@NO));
        });
    });
});

describe(@"a filter by module", ^{
    __block NSString *testFilterModuleName = @"filter module";
    __block SDLLogModel *testFilterModel = [[SDLLogModel alloc] initWithMessage:@"test" timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:testFilterModuleName functionName:@"test" line:0 queueLabel:@"test"];
    __block SDLLogFileModule *testFilterModule = [SDLLogFileModule moduleWithName:testFilterModuleName files:[NSSet setWithObject:@"test"]];

    __block NSString *testOtherModuleName = @"other module";
    __block SDLLogModel *testOtherModel = [[SDLLogModel alloc] initWithMessage:@"test" timestamp:[NSDate date] level:SDLLogLevelDebug fileName:@"test" moduleName:testOtherModuleName functionName:@"test" line:0 queueLabel:@"test"];

    context(@"that disallows modules", ^{
        SDLLogFilter *testFilter = [SDLLogFilter filterByDisallowingModules:[NSSet setWithObject:testFilterModule.name]];

        it(@"should fail a matching module", ^{
            BOOL pass = testFilter.filter(testFilterModel);
            expect(@(pass)).to(equal(@NO));
        });

        it(@"should pass a non-matching module", ^{
            BOOL pass = testFilter.filter(testOtherModel);
            expect(@(pass)).to(equal(@YES));
        });
    });

    context(@"that allows modules", ^{
        SDLLogFilter *testFilter = [SDLLogFilter filterByAllowingModules:[NSSet setWithObject:testFilterModule.name]];

        it(@"should pass a matching string", ^{
            BOOL pass = testFilter.filter(testFilterModel);
            expect(@(pass)).to(equal(@YES));
        });

        it(@"should fail a non-matching string", ^{
            BOOL pass = testFilter.filter(testOtherModel);
            expect(@(pass)).to(equal(@NO));
        });
    });
});

describe(@"a filter by file name", ^{
    __block NSString *testFilterFilename = @"filter file";
    __block SDLLogModel *testFilterModel = [[SDLLogModel alloc] initWithMessage:@"test" timestamp:[NSDate date] level:SDLLogLevelDebug fileName:testFilterFilename moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    __block NSString *testOtherModuleName = @"other file";
    __block SDLLogModel *testOtherModel = [[SDLLogModel alloc] initWithMessage:@"test" timestamp:[NSDate date] level:SDLLogLevelDebug fileName:testOtherModuleName moduleName:@"test" functionName:@"test" line:0 queueLabel:@"test"];

    context(@"that disallows modules", ^{
        SDLLogFilter *testFilter = [SDLLogFilter filterByDisallowingFileNames:[NSSet setWithObject:testFilterFilename]];

        it(@"should fail a matching module", ^{
            BOOL pass = testFilter.filter(testFilterModel);
            expect(@(pass)).to(equal(@NO));
        });

        it(@"should pass a non-matching module", ^{
            BOOL pass = testFilter.filter(testOtherModel);
            expect(@(pass)).to(equal(@YES));
        });
    });

    context(@"that allows modules", ^{
        SDLLogFilter *testFilter = [SDLLogFilter filterByAllowingFileNames:[NSSet setWithObject:testFilterFilename]];

        it(@"should pass a matching string", ^{
            BOOL pass = testFilter.filter(testFilterModel);
            expect(@(pass)).to(equal(@YES));
        });

        it(@"should fail a non-matching string", ^{
            BOOL pass = testFilter.filter(testOtherModel);
            expect(@(pass)).to(equal(@NO));
        });
    });
});


QuickSpecEnd
