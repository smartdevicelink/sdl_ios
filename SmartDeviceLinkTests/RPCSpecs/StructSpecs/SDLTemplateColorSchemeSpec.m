@import Quick;
@import Nimble;

#import "SDLRGBColor.h"
#import "SDLTemplateColorScheme.h"

#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLTemplateColorSchemeSpec)

describe(@"TemplateColor Tests", ^{
    __block SDLRGBColor *testRed = nil;
    __block SDLRGBColor *testGreen = nil;
    __block SDLRGBColor *testBlue = nil;

    beforeEach(^{
        testRed = [[SDLRGBColor alloc] initWithRed:255 green:0 blue:0];
        testGreen = [[SDLRGBColor alloc] initWithRed:0 green:255 blue:0];
        testBlue = [[SDLRGBColor alloc] initWithRed:0 green:0 blue:255];
    });

    it(@"Should set and get correctly", ^{
        SDLTemplateColorScheme *testStruct = [[SDLTemplateColorScheme alloc] init];

        testStruct.primaryColor = testRed;
        testStruct.secondaryColor = testGreen;
        testStruct.backgroundColor = testBlue;

        expect(testStruct.primaryColor).to(equal(testRed));
        expect(testStruct.secondaryColor).to(equal(testGreen));
        expect(testStruct.backgroundColor).to(equal(testBlue));
    });

    it(@"Should get correctly when initialized with parameters", ^{
        SDLTemplateColorScheme *testStruct = [[SDLTemplateColorScheme alloc] initWithPrimaryRGBColor:testRed secondaryRGBColor:testGreen backgroundRGBColor:testBlue];

        expect(testStruct.primaryColor).to(equal(testRed));
        expect(testStruct.secondaryColor).to(equal(testGreen));
        expect(testStruct.backgroundColor).to(equal(testBlue));
    });

    it(@"Should get correctly when initialized with colors", ^{
        UIColor *testRedColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        UIColor *testGreenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        UIColor *testBlueColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        SDLTemplateColorScheme *testStruct = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:testRedColor secondaryColor:testGreenColor backgroundColor:testBlueColor];

        expect(testStruct.primaryColor).to(equal(testRed));
        expect(testStruct.secondaryColor).to(equal(testGreen));
        expect(testStruct.backgroundColor).to(equal(testBlue));
    });

    it(@"Should get correctly when initialized with a dict", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRed: @0,
                               SDLRPCParameterNameGreen: @100,
                               SDLRPCParameterNameBlue: @255};
        SDLRGBColor *testStruct = [[SDLRGBColor alloc] initWithDictionary:dict];

        expect(testStruct.red).to(equal(@0));
        expect(testStruct.green).to(equal(@100));
        expect(testStruct.blue).to(equal(@255));
    });

    it(@"Should return nil if not set", ^{
        SDLRGBColor *testStruct = [[SDLRGBColor alloc] init];

        expect(testStruct.red).to(beNil());
        expect(testStruct.green).to(beNil());
        expect(testStruct.blue).to(beNil());
    });
});

QuickSpecEnd
