//
//  SDLOnHMIStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLOnHMIStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemContext.h"


QuickSpecBegin(SDLOnHMIStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLHMILevel testLevel = nil;
    __block SDLSystemContext testContext = nil;
    __block SDLAudioStreamingState testAudioState = nil;
    __block SDLVideoStreamingState testVideoState = nil;
    __block NSNumber<SDLInt> *testWindowID = nil;

     beforeEach(^{
        testLevel = SDLHMILevelFull;
        testContext = SDLSystemContextAlert;
        testAudioState = SDLAudioStreamingStateAttenuated;
        testVideoState = SDLVideoStreamingStateStreamable;
        testWindowID = @0;
    });

    it(@"Should set and get correctly", ^ {
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] init];
        
        testNotification.hmiLevel = testLevel;
        testNotification.audioStreamingState = testAudioState;
        testNotification.systemContext = testContext;
        testNotification.videoStreamingState = testVideoState;
        testNotification.windowID = testWindowID;
        
        expect(testNotification.hmiLevel).to(equal(testLevel));
        expect(testNotification.audioStreamingState).to(equal(testAudioState));
        expect(testNotification.systemContext).to(equal(testContext));
        expect(testNotification.videoStreamingState).to(equal(testVideoState));
        expect(testNotification.windowID).to(equal(testWindowID));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                @{SDLRPCParameterNameParameters:
                                      @{SDLRPCParameterNameHMILevel: testLevel,
                                        SDLRPCParameterNameAudioStreamingState: testAudioState,
                                        SDLRPCParameterNameSystemContext: testContext,
                                        SDLRPCParameterNameVideoStreamingState: testVideoState,
                                        SDLRPCParameterNameWindowId: testWindowID},
                                  SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnHMIStatus}};
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] initWithDictionary:dict];
        
        expect(testNotification.hmiLevel).to(equal(testLevel));
        expect(testNotification.audioStreamingState).to(equal(testAudioState));
        expect(testNotification.systemContext).to(equal(testContext));
        expect(testNotification.videoStreamingState).to(equal(testVideoState));
        expect(testNotification.windowID).to(equal(testWindowID));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] init];
        
        expect(testNotification.hmiLevel).to(beNil());
        expect(testNotification.audioStreamingState).to(beNil());
        expect(testNotification.systemContext).to(beNil());
        expect(testNotification.videoStreamingState).to(beNil());
        expect(testNotification.windowID).to(beNil());
    });

    it(@"should initialize properly with initWithHMILevel:systemContext:audioStreamingState:videoStreamingState:windowID:", ^{
        SDLOnHMIStatus *testStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:testLevel systemContext:testContext audioStreamingState:testAudioState videoStreamingState:testVideoState windowID:testWindowID];
        expect(testStatus.hmiLevel).to(equal(testLevel));
        expect(testStatus.systemContext).to(equal(testContext));
        expect(testStatus.audioStreamingState).to(equal(testAudioState));
        expect(testStatus.videoStreamingState).to(equal(testVideoState));
        expect(testStatus.windowID).to(equal(testWindowID));
    });
});

QuickSpecEnd
