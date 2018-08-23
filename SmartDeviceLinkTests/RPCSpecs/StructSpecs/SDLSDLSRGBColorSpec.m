//
//  SDLSDLSRGBColorSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSRGBColor.h"


QuickSpecBegin( SDLSDLSRGBColorSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSRGBColor* testStruct = [[SDLSRGBColor alloc] init];

        testStruct.red = @123;
        testStruct.green = @23;
        testStruct.blue = @54;

        expect(testStruct.red).to(equal(@123));
        expect(testStruct.green).to(equal(@23));
        expect(testStruct.blue).to(equal(@54));

    });

    it(@"Should set and get correctly", ^ {
        SDLSRGBColor* testStruct = [[SDLSRGBColor alloc] initWithRed:123 green:23 blue:54];

        expect(testStruct.red).to(equal(@123));
        expect(testStruct.green).to(equal(@23));
        expect(testStruct.blue).to(equal(@54));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRed:@123,
                                       SDLNameBlue:@23,
                                       SDLNameGreen:@54
                                       } mutableCopy];

        SDLSRGBColor* testStruct = [[SDLSRGBColor alloc] initWithDictionary:dict];

        expect(testStruct.red).to(equal(@123));
        expect(testStruct.green).to(equal(@54));
        expect(testStruct.blue).to(equal(@23));
    });

    it(@"Should return nil if not set", ^ {
        SDLSRGBColor* testStruct = [[SDLSRGBColor alloc] init];

        expect(testStruct.red).to(beNil());
        expect(testStruct.green).to(beNil());
        expect(testStruct.blue).to(beNil());

    });
});

QuickSpecEnd

