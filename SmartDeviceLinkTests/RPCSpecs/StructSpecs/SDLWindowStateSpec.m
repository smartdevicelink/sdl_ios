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

describe(@"getter/setter tests", ^ {
    context(@"initWithApproximatePosition:deviation:", ^{
        SDLWindowState *testStruct = [[SDLWindowState alloc] initWithApproximatePosition:approximatePosition deviation:deviation];
        it(@"expect all properties to be set properly", ^ {
            expect(testStruct.approximatePosition).to(equal(approximatePosition));
            expect(testStruct.deviation).to(equal(deviation));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary *dict = @{SDLRPCParameterNameDeviation:@(deviation), SDLRPCParameterNameApproximatePosition:@(approximatePosition)};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWindowState *testStruct = [[SDLWindowState alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        it(@"expect all properties to be set properly", ^ {
            expect(testStruct.approximatePosition).to(equal(approximatePosition));
            expect(testStruct.deviation).to(equal(deviation));
        });
    });

    context(@"init", ^{
        SDLWindowState *testStruct = [[SDLWindowState alloc] init];

        it(@"should return nil if not set", ^ {
            expect(testStruct.approximatePosition).to(beNil());
            expect(testStruct.deviation).to(beNil());
        });
    });
});

QuickSpecEnd
