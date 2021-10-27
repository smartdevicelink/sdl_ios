//
//  SDLNextFunctionInfoSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNextFunctionInfo.h"
#import "SDLRPCParameterNames.h"

@interface SDLNextFunctionInfo(discover_private_methods)
+ (nullable NSNumber<SDLUInt> *)nextFunctionFromFunctionName:(SDLRPCFunctionName)functionName;
+ (nullable SDLRPCFunctionName)functionNameFromNextFunction:(SDLNextFunction)nextFunction;
@end

QuickSpecBegin(SDLNextFunctionInfoSpec)

__block SDLNextFunctionInfo *nextFunctionInfo = nil;
SDLNextFunction nextFunction = SDLNextFunctionDialNumber;
NSString *loadingText = @"hello world";

describe(@"init", ^{
    beforeEach(^{
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] init];
    });

    it(@"should be set", ^{
        expect(nextFunctionInfo).notTo(beNil());
        expect(@(nextFunctionInfo.nextFunction)).to(equal(@(0)));
        expect(nextFunctionInfo.loadingText).to(beNil());
    });
});

describe(@"initWithNextFunction:loadingText:", ^{
    beforeEach(^{
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] initWithNextFunction:nextFunction loadingText:loadingText];
    });

    it(@"should be set", ^{
        expect(nextFunctionInfo).notTo(beNil());
        expect(@(nextFunctionInfo.nextFunction)).to(equal(@(SDLNextFunctionDialNumber)));
        expect(nextFunctionInfo.loadingText).to(equal(loadingText));
    });
});

describe(@"initWithDictionary:", ^{
    beforeEach(^{
        NSDictionary *dict = @{
            SDLRPCParameterNameNextFunctionID: SDLRPCFunctionNameDialNumber,
            SDLRPCParameterNameLoadingText: loadingText,
        };
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] initWithDictionary:dict];
    });

    it(@"should be set", ^{
        expect(nextFunctionInfo).notTo(beNil());
        expect(@(nextFunctionInfo.nextFunction)).to(equal(@(SDLNextFunctionDialNumber)));
        expect(nextFunctionInfo.loadingText).to(equal(loadingText));
    });
});

describe(@"internal functions test", ^{
    it(@"nextFunctionFromFunctionName:", ^{
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameDefault]).to(equal(@(SDLNextFunctionDefault)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNamePerformChoiceSet]).to(equal(@(SDLNextFunctionPerformChoiceSet)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameAlert]).to(equal(@(SDLNextFunctionAlert)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameScreenUpdate]).to(equal(@(SDLNextFunctionScreenUpdate)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameSpeak]).to(equal(@(SDLNextFunctionSpeak)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameAccessMicrophone]).to(equal(@(SDLNextFunctionAccessMicrophone)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameScrollableMessage]).to(equal(@(SDLNextFunctionScrollableMessage)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameSlider]).to(equal(@(SDLNextFunctionSlider)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameSendLocation]).to(equal(@(SDLNextFunctionSendLocation)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameDialNumber]).to(equal(@(SDLNextFunctionDialNumber)));
        expect([SDLNextFunctionInfo nextFunctionFromFunctionName:SDLRPCFunctionNameOpenMenu]).to(equal(@(SDLNextFunctionOpenMenu)));
    });

    it(@"functionNameFromNextFunction:", ^{
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionDefault]).to(equal(SDLRPCFunctionNameDefault));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionPerformChoiceSet]).to(equal(SDLRPCFunctionNamePerformChoiceSet));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionAlert]).to(equal(SDLRPCFunctionNameAlert));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionScreenUpdate]).to(equal(SDLRPCFunctionNameScreenUpdate));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionSpeak]).to(equal(SDLRPCFunctionNameSpeak));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionAccessMicrophone]).to(equal(SDLRPCFunctionNameAccessMicrophone));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionScrollableMessage]).to(equal(SDLRPCFunctionNameScrollableMessage));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionSlider]).to(equal(SDLRPCFunctionNameSlider));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionSendLocation]).to(equal(SDLRPCFunctionNameSendLocation));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionDialNumber]).to(equal(SDLRPCFunctionNameDialNumber));
        expect([SDLNextFunctionInfo functionNameFromNextFunction:SDLNextFunctionOpenMenu]).to(equal(SDLRPCFunctionNameOpenMenu));
    });

    it(@"description", ^{
        // make codecov happy
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] init];
        expect(nextFunctionInfo.description).notTo(beNil());
    });
});

QuickSpecEnd
