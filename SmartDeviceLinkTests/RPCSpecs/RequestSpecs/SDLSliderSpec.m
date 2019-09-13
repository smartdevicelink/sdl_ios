//
//  SDLSliderSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSlider.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSliderSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLSlider *testRequest = nil;
    __block UInt8 testNumTicks = 4;
    __block UInt8 testPosition = 1;
    __block NSUInteger testTimeout = 2000;
    __block NSString *testHeader = @"Head";
    __block NSString *testFooter = @"Foot";
    __block NSArray<NSString *> *testFooters = @[@"Foot1", @"Foot2"];
    __block int testCancelID = 56;

    context(@"Getter/Setter Tests", ^{
        it(@"Should set and get correctly", ^ {
            testRequest = [[SDLSlider alloc] init];

            testRequest.numTicks = @(testNumTicks);
            testRequest.position = @(testPosition);
            testRequest.sliderHeader = testHeader;
            testRequest.sliderFooter = testFooters;
            testRequest.timeout = @(testTimeout);
            testRequest.cancelID = @(testCancelID);

            expect(testRequest.numTicks).to(equal(testNumTicks));
            expect(testRequest.position).to(equal(testPosition));
            expect(testRequest.sliderHeader).to(equal(testHeader));
            expect(testRequest.sliderFooter).to(equal(testFooters));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(6));
        });

        it(@"Should return nil if not set", ^ {
            testRequest = [[SDLSlider alloc] init];

            expect(testRequest.numTicks).to(beNil());
            expect(testRequest.position).to(beNil());
            expect(testRequest.sliderHeader).to(beNil());
            expect(testRequest.sliderFooter).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.cancelID).to(beNil());

            expect(testRequest.parameters.count).to(equal(0));
        });
    });

    describe(@"Initializing", ^{
        it(@"Should get correctly when initialized with a dictionary", ^ {
            NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                       @{SDLRPCParameterNameParameters:
                                                             @{SDLRPCParameterNameNumberTicks:@(testNumTicks),
                                                               SDLRPCParameterNamePosition:@(testPosition),
                                                               SDLRPCParameterNameSliderHeader:testHeader,
                                                               SDLRPCParameterNameSliderFooter:testFooters,
                                                               SDLRPCParameterNameTimeout:@(testTimeout),
                                                               SDLRPCParameterNameCancelID:@(testCancelID)
                                                               },
                                                         SDLRPCParameterNameOperationName:SDLRPCFunctionNameSlider}};
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLSlider alloc] initWithDictionary:dict];
            #pragma clang diagnostic pop

            expect(testRequest.numTicks).to(equal(testNumTicks));
            expect(testRequest.position).to(equal(testPosition));
            expect(testRequest.sliderHeader).to(equal(testHeader));
            expect(testRequest.sliderFooter).to(equal(testFooters));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"should correctly initialize with initWithNumTicks:position:sliderHeader:sliderFooters:timeout:cancelID:", ^{
            testRequest = [[SDLSlider alloc] initWithNumTicks:testNumTicks position:testPosition sliderHeader:testHeader sliderFooters:testFooters timeout:testTimeout cancelID:testCancelID];

            expect(testRequest.numTicks).to(equal(testNumTicks));
            expect(testRequest.position).to(equal(testPosition));
            expect(testRequest.sliderHeader).to(equal(testHeader));
            expect(testRequest.sliderFooter).to(equal(testFooters));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"should correctly initialize with initWithNumTicks:position:", ^{
            testRequest = [[SDLSlider alloc] initWithNumTicks:testNumTicks position:testPosition];

            expect(testRequest.numTicks).to(equal(testNumTicks));
            expect(testRequest.position).to(equal(testPosition));
            expect(testRequest.sliderHeader).to(beNil());
            expect(testRequest.sliderFooter).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"should correctly initialize with initWithNumTicks:position:sliderHeader:sliderFooters:timeout:", ^{
            testRequest = [[SDLSlider alloc] initWithNumTicks:testNumTicks position:testPosition sliderHeader:testHeader sliderFooters:testFooters timeout:testTimeout];

            expect(testRequest.numTicks).to(equal(testNumTicks));
            expect(testRequest.position).to(equal(testPosition));
            expect(testRequest.sliderHeader).to(equal(testHeader));
            expect(testRequest.sliderFooter).to(equal(testFooters));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"should correctly initialize with initWithNumTicks:position:sliderHeader:sliderFooter:timeout:", ^{
            testRequest = [[SDLSlider alloc] initWithNumTicks:testNumTicks position:testPosition sliderHeader:testHeader sliderFooter:testFooter timeout:testTimeout];

            expect(testRequest.numTicks).to(equal(testNumTicks));
            expect(testRequest.position).to(equal(testPosition));
            expect(testRequest.sliderHeader).to(equal(testHeader));
            expect(testRequest.sliderFooter).to(equal(@[testFooter]));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.cancelID).to(beNil());
        });
    });

    afterEach(^{
        expect(testRequest.name).to(equal(SDLRPCFunctionNameSlider));
    });
});

QuickSpecEnd
