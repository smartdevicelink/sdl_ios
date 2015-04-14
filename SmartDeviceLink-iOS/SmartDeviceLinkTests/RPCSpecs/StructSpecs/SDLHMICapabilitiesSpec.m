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
    
    context(@"When initialized with properties", ^{
        beforeEach(^{
            testStruct = [[SDLHMICapabilities alloc] init];
            testStruct.phoneCall = somePhoneCallState;
            testStruct.navigation = someNavigationState;
        });
        
        it(@"should properly set phone call", ^{
            expect(testStruct.phoneCall).to(equal(somePhoneCallState));
        });
        
        it(@"should properly set navigation", ^{
            expect(testStruct.navigation).to(equal(someNavigationState));
        });
    });
    
    context(@"When initialized with a dictionary", ^{
        beforeEach(^{
            NSDictionary *structInitDict = @{
                                             NAMES_navigation: someNavigationState,
                                             NAMES_phoneCall: somePhoneCallState
                                             };
            testStruct = [[SDLHMICapabilities alloc] initWithDictionary:[structInitDict mutableCopy]];
        });
        
        it(@"should properly set phone call", ^{
            expect(testStruct.phoneCall).to(equal(somePhoneCallState));
        });
        
        it(@"should properly set navigation", ^{
            expect(testStruct.navigation).to(equal(someNavigationState));
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
    });
});

QuickSpecEnd
