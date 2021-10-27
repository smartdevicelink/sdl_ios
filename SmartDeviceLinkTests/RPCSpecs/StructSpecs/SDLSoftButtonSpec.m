//
//  SDLSoftButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImage.h"
#import "SDLNextFunctionInfo.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"


QuickSpecBegin(SDLSoftButtonSpec)

SDLImage* image = [[SDLImage alloc] init];
__block SDLNextFunctionInfo *nextFunctionInfo = nil;

describe(@"Getter/Setter Tests", ^ {
    beforeEach(^{
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] init];
    });

    it(@"Should set and get correctly", ^ {
        SDLSoftButton* testStruct = [[SDLSoftButton alloc] init];
        
        testStruct.type = SDLSoftButtonTypeImage;
        testStruct.text = @"Button";
        testStruct.image = image;
        testStruct.isHighlighted = @YES;
        testStruct.softButtonID = @5423;
        testStruct.systemAction = SDLSystemActionKeepContext;
        testStruct.nextFunctionInfo = nextFunctionInfo;
        
        expect(testStruct.type).to(equal(SDLSoftButtonTypeImage));
        expect(testStruct.text).to(equal(@"Button"));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.isHighlighted).to(equal(@YES));
        expect(testStruct.softButtonID).to(equal(@5423));
        expect(testStruct.systemAction).to(equal(SDLSystemActionKeepContext));
        expect(testStruct.nextFunctionInfo).to(equal(nextFunctionInfo));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameType:SDLSoftButtonTypeImage,
                                       SDLRPCParameterNameText:@"Button",
                                       SDLRPCParameterNameImage:image,
                                       SDLRPCParameterNameIsHighlighted:@YES,
                                       SDLRPCParameterNameSoftButtonId:@5423,
                                       SDLRPCParameterNameSystemAction:SDLSystemActionKeepContext,
                                       SDLRPCParameterNameNextFunctionInfo: nextFunctionInfo,
        };
        SDLSoftButton* testStruct = [[SDLSoftButton alloc] initWithDictionary:dict];
        
        expect(testStruct.type).to(equal(SDLSoftButtonTypeImage));
        expect(testStruct.text).to(equal(@"Button"));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.isHighlighted).to(equal(@YES));
        expect(testStruct.softButtonID).to(equal(@5423));
        expect(testStruct.systemAction).to(equal(SDLSystemActionKeepContext));
        expect(testStruct.nextFunctionInfo).to(equal(nextFunctionInfo));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSoftButton* testStruct = [[SDLSoftButton alloc] init];
        
        expect(testStruct.type).to(beNil());
        expect(testStruct.text).to(beNil());
        expect(testStruct.image).to(beNil());
        expect(testStruct.isHighlighted).to(beNil());
        expect(testStruct.softButtonID).to(beNil());
        expect(testStruct.systemAction).to(beNil());
        expect(testStruct.nextFunctionInfo).to(beNil());
    });
});

describe(@"copy test", ^{
    __block SDLSoftButton *testButton1 = nil;
    __block SDLSoftButton *testButton2 = nil;

    beforeEach(^{
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] init];
        testButton1 = [[SDLSoftButton alloc] init];
        testButton1.nextFunctionInfo = nextFunctionInfo;
        testButton2 = [testButton1 copy];
    });

    it(@"should get correctly when initialized", ^{
        expect(testButton2).notTo(beNil());
        expect(testButton2.nextFunctionInfo).to(equal(nextFunctionInfo));
    });
});

QuickSpecEnd
