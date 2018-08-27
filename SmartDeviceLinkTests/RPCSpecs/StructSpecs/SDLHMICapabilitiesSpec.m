//
//  SDLHMICapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMICapabilities.h"
#import "SDLNames.h"


QuickSpecBegin(SDLHMICapabilitiesSpec)

describe(@"SDLHMICapabilities struct", ^{
    __block SDLHMICapabilities *testStruct = nil;
    __block NSNumber *somePhoneCallState = @NO;
    __block NSNumber *someNavigationState = @YES;
    __block NSNumber *someVideoStreamState = @NO;
    
    context(@"When initialized with properties", ^{
        beforeEach(^{
            testStruct = [[SDLHMICapabilities alloc] init];
            testStruct.phoneCall = somePhoneCallState;
            testStruct.navigation = someNavigationState;
            testStruct.videoStreaming = someVideoStreamState;
        });
        
        it(@"should properly set phone call", ^{
            expect(testStruct.phoneCall).to(equal(somePhoneCallState));
        });
        
        it(@"should properly set navigation", ^{
            expect(testStruct.navigation).to(equal(someNavigationState));
        });

        it(@"should properly set video streaming", ^{
            expect(testStruct.videoStreaming).to(equal(someVideoStreamState));
        });
    });
    
    context(@"When initialized with a dictionary", ^{
        beforeEach(^{
            NSDictionary<NSString *, NSNumber *> *structInitDict = @{
                                             SDLNameNavigation: someNavigationState,
                                             SDLNamePhoneCall: somePhoneCallState,
                                             SDLNameVideoStreaming: someVideoStreamState
                                             };
            testStruct = [[SDLHMICapabilities alloc] initWithDictionary:[structInitDict mutableCopy]];
        });
        
        it(@"should properly set phone call", ^{
            expect(testStruct.phoneCall).to(equal(somePhoneCallState));
        });
        
        it(@"should properly set navigation", ^{
            expect(testStruct.navigation).to(equal(someNavigationState));
        });

        it(@"should properly set video streaming", ^{
            expect(testStruct.videoStreaming).to(equal(someVideoStreamState));
        });
    });
    
    context(@"When not initialized", ^{
        beforeEach(^{
            testStruct = nil;
        });
        
        it(@"phoneCall should be nil", ^{
            expect(testStruct.phoneCall).to(beNil());
        });
        
        it(@"navigation should be nil", ^{
            expect(testStruct.navigation).to(beNil());
        });

        it(@"video streaming should be nil", ^{
            expect(testStruct.videoStreaming).to(beNil());
        });
    });
});

QuickSpecEnd
