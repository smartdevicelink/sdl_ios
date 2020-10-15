//
//  SDLSetDisplayLayoutSpec.m
//  SmartDeviceLink

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSetDisplayLayout.h"
#import "SDLTemplateColorScheme.h"

QuickSpecBegin(SDLSetDisplayLayoutSpec)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
describe(@"SetDisplayLayout Tests", ^ {
    __block SDLPredefinedLayout predefinedLayout = SDLPredefinedLayoutMedia;
    __block NSString *otherLayout = @"test123";
    __block SDLTemplateColorScheme *dayScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:[UIColor blueColor] secondaryColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    __block SDLTemplateColorScheme *nightScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:[UIColor blueColor] secondaryColor:[UIColor purpleColor] backgroundColor:[UIColor blackColor]];

    describe(@"initializer tests", ^{
        it(@"should initialize with initWithPredefinedLayout:", ^{
            SDLSetDisplayLayout *testRequest = [[SDLSetDisplayLayout alloc] initWithPredefinedLayout:predefinedLayout];

            expect(testRequest.displayLayout).to(equal(predefinedLayout));
            expect(testRequest.dayColorScheme).to(beNil());
            expect(testRequest.nightColorScheme).to(beNil());
        });

        it(@"should initialize with initWithLayout:", ^{
            SDLSetDisplayLayout *testRequest = [[SDLSetDisplayLayout alloc] initWithLayout:otherLayout];

            expect(testRequest.displayLayout).to(equal(otherLayout));
            expect(testRequest.dayColorScheme).to(beNil());
            expect(testRequest.nightColorScheme).to(beNil());
        });

        it(@"should initialize with initWithPredefinedLayout:dayColorScheme:nightColorScheme:", ^{
            SDLSetDisplayLayout *testRequest = [[SDLSetDisplayLayout alloc] initWithPredefinedLayout:predefinedLayout dayColorScheme:dayScheme nightColorScheme:nightScheme];

            expect(testRequest.displayLayout).to(equal(predefinedLayout));
            expect(testRequest.dayColorScheme).to(equal(dayScheme));
            expect(testRequest.nightColorScheme).to(equal(nightScheme));
        });

        it(@"Should get correctly when initialized", ^ {
            NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                               @{SDLRPCParameterNameParameters:
                                                                     @{SDLRPCParameterNameDisplayLayout:@"wat"},
                                                                 SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetDisplayLayout}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetDisplayLayout* testRequest = [[SDLSetDisplayLayout alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

            expect(testRequest.displayLayout).to(equal(@"wat"));
        });

        it(@"Should return nil if not set", ^ {
            SDLSetDisplayLayout* testRequest = [[SDLSetDisplayLayout alloc] init];

            expect(testRequest.displayLayout).to(beNil());
        });
    });

    describe(@"getters/setter", ^{
        it(@"Should set and get correctly", ^ {
            SDLSetDisplayLayout* testRequest = [[SDLSetDisplayLayout alloc] init];

            testRequest.displayLayout = otherLayout;
            testRequest.dayColorScheme = dayScheme;
            testRequest.nightColorScheme = nightScheme;

            expect(testRequest.displayLayout).to(equal(otherLayout));
            expect(testRequest.dayColorScheme).to(equal(dayScheme));
            expect(testRequest.nightColorScheme).to(equal(nightScheme));
        });
    });
});
#pragma clang diagnostic pop

QuickSpecEnd
