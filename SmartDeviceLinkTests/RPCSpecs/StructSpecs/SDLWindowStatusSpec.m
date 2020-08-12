//
//  SDLWindowStatusSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>
#import "SDLGrid.h"
#import "SDLRPCParameterNames.h"
#import "SDLWindowState.h"
#import "SDLWindowStatus.h"

const UInt8 approximatePosition = 13;
const UInt8 deviation = 42;

QuickSpecBegin(SDLWindowStatusSpec)

describe(@"getter/setter tests", ^{
    context(@"initWithLocation:state", ^{
        SDLWindowState *state = [[SDLWindowState alloc] initWithApproximatePosition:approximatePosition deviation:deviation];
        SDLGrid *location = [[SDLGrid alloc] init];
        SDLWindowStatus *testStruct = [[SDLWindowStatus alloc] initWithLocation:location state:state];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.state).to(equal(state));
        });
    });

    context(@"initWithDictionary:", ^{
        SDLWindowState *state = [[SDLWindowState alloc] initWithApproximatePosition:approximatePosition deviation:deviation];
        SDLGrid *location = [[SDLGrid alloc] init];
        NSDictionary *dict = @{SDLRPCParameterNameLocation:location, SDLRPCParameterNameState:state};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWindowStatus *testStruct = [[SDLWindowStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
    
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.state).to(equal(state));
        });
    });

    context(@"init", ^{
        SDLWindowStatus *testStruct = [[SDLWindowStatus alloc] init];

        it(@"should return nil if not set", ^{
            expect(testStruct.location).to(beNil());
            expect(testStruct.state).to(beNil());
        });
    });
});

QuickSpecEnd
