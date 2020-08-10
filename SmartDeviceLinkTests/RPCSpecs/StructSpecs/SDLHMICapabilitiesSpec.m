//
//  SDLHMICapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMICapabilities.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLHMICapabilitiesSpec)

describe(@"SDLHMICapabilities struct", ^{
    __block SDLHMICapabilities *testStruct = nil;
    __block NSNumber *somePhoneCallState = @NO;
    __block NSNumber *someNavigationState = @YES;
    __block NSNumber *someVideoStreamState = @NO;
    __block NSNumber *someRemoteControlState = @YES;
    __block NSNumber *someAppServicesState = @YES;
    __block NSNumber *someDisplaysState = @YES;
    __block NSNumber *someSeatLocationState = @NO;
    __block NSNumber *someDriverDistractionState = @NO;
    
    context(@"when initialized with properties", ^{
        beforeEach(^{
            testStruct = [[SDLHMICapabilities alloc] init];
            testStruct.phoneCall = somePhoneCallState;
            testStruct.navigation = someNavigationState;
            testStruct.videoStreaming = someVideoStreamState;
            testStruct.remoteControl = someRemoteControlState;
            testStruct.appServices = someAppServicesState;
            testStruct.displays = someDisplaysState;
            testStruct.seatLocation = someSeatLocationState;
            testStruct.driverDistraction = someDriverDistractionState;
        });
        
        it(@"should properly set properties", ^{
            expect(testStruct.phoneCall).to(equal(somePhoneCallState));
            expect(testStruct.navigation).to(equal(someNavigationState));
            expect(testStruct.videoStreaming).to(equal(someVideoStreamState));
            expect(testStruct.remoteControl).to(equal(someRemoteControlState));
            expect(testStruct.appServices).to(equal(someAppServicesState));
            expect(testStruct.displays).to(equal(someDisplaysState));
            expect(testStruct.seatLocation).to(equal(someSeatLocationState));
            expect(testStruct.driverDistraction).to(equal(someDriverDistractionState));
        });
    });
    
    context(@"when initialized with a dictionary", ^{
        beforeEach(^{
            NSDictionary<NSString *, NSNumber *> *structInitDict = @{
                                             SDLRPCParameterNameNavigation: someNavigationState,
                                             SDLRPCParameterNamePhoneCall: somePhoneCallState,
                                             SDLRPCParameterNameVideoStreaming: someVideoStreamState,
                                             SDLRPCParameterNameRemoteControl: someRemoteControlState,
                                             SDLRPCParameterNameAppServices: someAppServicesState,
                                             SDLRPCParameterNameDisplays: someDisplaysState,
                                             SDLRPCParameterNameSeatLocation: someSeatLocationState,
                                             SDLRPCParameterNameDriverDistraction: someDriverDistractionState
                                             };

            testStruct = [[SDLHMICapabilities alloc] initWithDictionary:structInitDict];
        });
        
        it(@"should properly set properties", ^{
            expect(testStruct.phoneCall).to(equal(somePhoneCallState));
            expect(testStruct.navigation).to(equal(someNavigationState));
            expect(testStruct.videoStreaming).to(equal(someVideoStreamState));
            expect(testStruct.remoteControl).to(equal(someRemoteControlState));
            expect(testStruct.appServices).to(equal(someAppServicesState));
            expect(testStruct.displays).to(equal(someDisplaysState));
            expect(testStruct.seatLocation).to(equal(someSeatLocationState));
            expect(testStruct.driverDistraction).to(equal(someDriverDistractionState));
        });
    });
    
    context(@"when initialized", ^{
        context(@"with no parameters", ^{
            beforeEach(^{
                testStruct = [[SDLHMICapabilities alloc] init];
            });

            it(@"properties should be nil", ^{
                expect(testStruct.phoneCall).to(beNil());
                expect(testStruct.navigation).to(beNil());
                expect(testStruct.videoStreaming).to(beNil());
                expect(testStruct.remoteControl).to(beNil());
                expect(testStruct.displays).to(beNil());
                expect(testStruct.seatLocation).to(beNil());
                expect(testStruct.appServices).to(beNil());
            });
        });

        context(@"with initWithNavigation:phoneCall:videoStreaming:remoteControl:appServices:displays:seatLocation:driverDistraction:", ^{
            beforeEach(^{
                testStruct = [[SDLHMICapabilities alloc] initWithNavigation:someNavigationState phoneCall:somePhoneCallState videoStreaming:someVideoStreamState remoteControl:someRemoteControlState appServices:someAppServicesState displays:someDisplaysState seatLocation:someSeatLocationState driverDistraction:someDriverDistractionState];
            });

            it(@"properties should be nil", ^{
                expect(testStruct.phoneCall).to(equal(somePhoneCallState));
                expect(testStruct.navigation).to(equal(someNavigationState));
                expect(testStruct.videoStreaming).to(equal(someVideoStreamState));
                expect(testStruct.remoteControl).to(equal(someRemoteControlState));
                expect(testStruct.appServices).to(equal(someAppServicesState));
                expect(testStruct.displays).to(equal(someDisplaysState));
                expect(testStruct.seatLocation).to(equal(someSeatLocationState));
                expect(testStruct.driverDistraction).to(equal(someDriverDistractionState));
            });
        });
    });
});

QuickSpecEnd
