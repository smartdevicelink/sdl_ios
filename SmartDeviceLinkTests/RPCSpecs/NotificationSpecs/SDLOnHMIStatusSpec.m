//
//  SDLOnHMIStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLOnHMIStatus.h"
#import "SDLNames.h"
#import "SDLSystemContext.h"


QuickSpecBegin(SDLOnHMIStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] init];
        
        testNotification.hmiLevel = SDLHMILevelLimited;
        testNotification.audioStreamingState = SDLAudioStreamingStateAttenuated;
        testNotification.systemContext = SDLSystemContextHMIObscured;
        
        expect(testNotification.hmiLevel).to(equal(SDLHMILevelLimited));
        expect(testNotification.audioStreamingState).to(equal(SDLAudioStreamingStateAttenuated));
        expect(testNotification.systemContext).to(equal(SDLSystemContextHMIObscured));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{SDLNameHMILevel:SDLHMILevelLimited,
                                                   SDLNameAudioStreamingState:SDLAudioStreamingStateAttenuated,
                                                   SDLNameSystemContext:SDLSystemContextHMIObscured},
                                             SDLNameOperationName:SDLNameOnHMIStatus}} mutableCopy];
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] initWithDictionary:dict];
        
        expect(testNotification.hmiLevel).to(equal(SDLHMILevelLimited));
        expect(testNotification.audioStreamingState).to(equal(SDLAudioStreamingStateAttenuated));
        expect(testNotification.systemContext).to(equal(SDLSystemContextHMIObscured));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] init];
        
        expect(testNotification.hmiLevel).to(beNil());
        expect(testNotification.audioStreamingState).to(beNil());
        expect(testNotification.systemContext).to(beNil());
    });
});

QuickSpecEnd
