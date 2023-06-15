@import Quick;
@import Nimble;

#import "SDLMsgVersion.h"
#import "SDLVersion.h"

QuickSpecBegin(SDLVersionSpec)

describe(@"a version object", ^{
    __block SDLVersion *testVersion = nil;
    __block NSUInteger major = 5; __block NSUInteger minor = 4; __block NSUInteger patch = 0;

    beforeEach(^{
        testVersion = nil;
    });

    describe(@"initializers", ^{
        context(@"created from numbers", ^{
            it(@"should match the parameters", ^{
                testVersion = [[SDLVersion alloc] initWithMajor:major minor:minor patch:patch];
                expect(testVersion.major).to(equal(major));
                expect(testVersion.minor).to(equal(minor));
                expect(testVersion.patch).to(equal(patch));
            });
        });

        context(@"created from a string", ^{
            NSString *goodVersionString = [NSString stringWithFormat:@"%lu.%lu.%lu", major, minor, patch];
            NSString *badVersionStringShort = @"1.";
            NSString *badVersionStringLong = @"3.1.0.0";

            it(@"should throw with a bad short string", ^{
                expectAction(^{
                    testVersion = [[SDLVersion alloc] initWithString:badVersionStringShort];
                }).to(raiseException());
            });

            it(@"should throw with a bad long string", ^{
                expectAction(^{
                    testVersion = [[SDLVersion alloc] initWithString:badVersionStringLong];
                }).to(raiseException());
            });

            it(@"should match the good string", ^{
                testVersion = [[SDLVersion alloc] initWithString:goodVersionString];
                expect(testVersion.major).to(equal(major));
                expect(testVersion.minor).to(equal(minor));
                expect(testVersion.patch).to(equal(patch));
            });

            it(@"should fail with negative numbers", ^{
                expectAction(^{
                    testVersion = [[SDLVersion alloc] initWithString:@"-1.-2.-3"];
                }).to(raiseException());
            });
        });

        context(@"created from a SDLMsgVersion object", ^{
            beforeEach(^{
                SDLMsgVersion *msgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:major minorVersion:minor patchVersion:patch];
                testVersion = [[SDLVersion alloc] initWithSDLMsgVersion:msgVersion];
            });

            it(@"should match the parameters", ^{
                expect(testVersion.major).to(equal(major));
                expect(testVersion.minor).to(equal(minor));
                expect(testVersion.patch).to(equal(patch));
            });
        });
    });

    describe(@"comparing versions", ^{
        __block SDLVersion *lowerVersion = nil;
        __block SDLVersion *equalVersion = nil;
        __block SDLVersion *higherVersion = nil;

        beforeEach(^{
            testVersion = [[SDLVersion alloc] initWithMajor:major minor:minor patch:patch];
            lowerVersion = [[SDLVersion alloc] initWithMajor:4 minor:1 patch:0];
            equalVersion = [[SDLVersion alloc] initWithMajor:major minor:minor patch:patch];
            higherVersion = [[SDLVersion alloc] initWithMajor:7 minor:2 patch:4];
        });

        it(@"should correctly check comparison methods", ^{
            expect([testVersion isGreaterThanVersion:lowerVersion]).to(equal(YES));
            expect([testVersion isGreaterThanVersion:equalVersion]).to(equal(NO));
            expect([testVersion isGreaterThanVersion:higherVersion]).to(equal(NO));
            expect([testVersion isEqualToVersion:lowerVersion]).to(equal(NO));
            expect([testVersion isEqualToVersion:equalVersion]).to(equal(YES));
            expect([testVersion isEqualToVersion:higherVersion]).to(equal(NO));
            expect([testVersion isLessThanVersion:lowerVersion]).to(equal(NO));
            expect([testVersion isLessThanVersion:equalVersion]).to(equal(NO));
            expect([testVersion isLessThanVersion:higherVersion]).to(equal(YES));
            expect([testVersion isGreaterThanOrEqualToVersion:equalVersion]).to(equal(YES));
            expect([testVersion isGreaterThanOrEqualToVersion:lowerVersion]).to(equal(YES));
            expect([testVersion isLessThanOrEqualToVersion:equalVersion]).to(equal(YES));
            expect([testVersion isLessThanVersion:higherVersion]).to(equal(YES));
        });
    });

    it(@"should correctly turn into a string", ^{
        testVersion = [[SDLVersion alloc] initWithMajor:major minor:minor patch:patch];
        expect(testVersion.stringVersion).to(equal(@"5.4.0"));
    });
});

QuickSpecEnd
