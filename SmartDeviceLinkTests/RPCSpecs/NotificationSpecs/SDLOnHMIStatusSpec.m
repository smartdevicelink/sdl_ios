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
        
        testNotification.hmiLevel = [SDLHMILevel LIMITED];
        testNotification.audioStreamingState = [SDLAudioStreamingState ATTENUATED];
        testNotification.systemContext = [SDLSystemContext HMI_OBSCURED];
        
        expect(testNotification.hmiLevel).to(equal([SDLHMILevel LIMITED]));
        expect(testNotification.audioStreamingState).to(equal([SDLAudioStreamingState ATTENUATED]));
        expect(testNotification.systemContext).to(equal([SDLSystemContext HMI_OBSCURED]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameNotification:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameHMILevel:[SDLHMILevel LIMITED],
                                                                   SDLNameAudioStreamingState:[SDLAudioStreamingState ATTENUATED],
                                                                   SDLNameSystemContext:[SDLSystemContext HMI_OBSCURED]},
                                                             SDLNameOperationName:SDLNameOnHMIStatus}} mutableCopy];
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] initWithDictionary:dict];
        
        expect(testNotification.hmiLevel).to(equal([SDLHMILevel LIMITED]));
        expect(testNotification.audioStreamingState).to(equal([SDLAudioStreamingState ATTENUATED]));
        expect(testNotification.systemContext).to(equal([SDLSystemContext HMI_OBSCURED]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] init];
        
        expect(testNotification.hmiLevel).to(beNil());
        expect(testNotification.audioStreamingState).to(beNil());
        expect(testNotification.systemContext).to(beNil());
    });
});

QuickSpecEnd
