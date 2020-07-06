//
//  SDLWindowStateSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>
#import "SDLRPCParameterNames.h"
#import "SDLWindowState.h"

QuickSpecBegin(SDLWindowStateSpec)

const UInt8 approximatePosition = 13;
const UInt8 deviation = 42;

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLWindowState *testStruct = [[SDLWindowState alloc] initWithApproximatePosition:approximatePosition deviation:deviation];

        expect(testStruct.approximatePosition).to(equal(approximatePosition));
        expect(testStruct.deviation).to(equal(deviation));
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameDeviation:@(deviation),
                                SDLRPCParameterNameApproximatePosition:@(approximatePosition)
                                };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWindowState *testStruct = [[SDLWindowState alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.approximatePosition).to(equal(approximatePosition));
        expect(testStruct.deviation).to(equal(deviation));
    });

    it(@"Should return nil if not set", ^ {
        SDLWindowState *testStruct = [[SDLWindowState alloc] init];

        expect(testStruct.approximatePosition).to(beNil());
        expect(testStruct.deviation).to(beNil());
    });
});

QuickSpecEnd
