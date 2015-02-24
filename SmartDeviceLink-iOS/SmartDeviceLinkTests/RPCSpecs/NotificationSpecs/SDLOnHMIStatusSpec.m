//
//  SDLOnHMIStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/27/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnHMIStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnHMIStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] init];
        
        testNotification.hmiLevel = [SDLHMILevel HMI_LIMITED];
        testNotification.audioStreamingState = [SDLAudioStreamingState ATTENUATED];
        testNotification.systemContext = [SDLSystemContext HMI_OBSCURED];
        
        expect(testNotification.hmiLevel).to(equal([SDLHMILevel HMI_LIMITED]));
        expect(testNotification.audioStreamingState).to(equal([SDLAudioStreamingState ATTENUATED]));
        expect(testNotification.systemContext).to(equal([SDLSystemContext HMI_OBSCURED]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_hmiLevel:[SDLHMILevel HMI_LIMITED],
                                                   NAMES_audioStreamingState:[SDLAudioStreamingState ATTENUATED],
                                                   NAMES_systemContext:[SDLSystemContext HMI_OBSCURED]},
                                             NAMES_operation_name:NAMES_OnHMIStatus}} mutableCopy];
        SDLOnHMIStatus* testNotification = [[SDLOnHMIStatus alloc] initWithDictionary:dict];
        
        expect(testNotification.hmiLevel).to(equal([SDLHMILevel HMI_LIMITED]));
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