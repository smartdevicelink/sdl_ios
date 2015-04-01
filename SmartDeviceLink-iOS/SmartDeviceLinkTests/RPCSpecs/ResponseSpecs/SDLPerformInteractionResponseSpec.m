//
//  SDLPerformInteractionResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPerformInteractionResponse.h"
#import "SDLNames.h"
#import "SDLTriggerSource.h"


QuickSpecBegin(SDLPerformInteractionResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPerformInteractionResponse* testResponse = [[SDLPerformInteractionResponse alloc] init];
        
        testResponse.choiceID = @25;
        testResponse.manualTextEntry = @"entry";
        testResponse.triggerSource = [SDLTriggerSource KEYBOARD];
        
        expect(testResponse.choiceID).to(equal(@25));
        expect(testResponse.manualTextEntry).to(equal(@"entry"));
        expect(testResponse.triggerSource).to(equal([SDLTriggerSource KEYBOARD]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                          @{NAMES_parameters:
                                                @{NAMES_choiceID:@25,
                                                  NAMES_manualTextEntry:@"entry",
                                                  NAMES_triggerSource:[SDLTriggerSource KEYBOARD]},
                                            NAMES_operation_name:NAMES_PerformInteraction}} mutableCopy];
        SDLPerformInteractionResponse* testResponse = [[SDLPerformInteractionResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.choiceID).to(equal(@25));
        expect(testResponse.manualTextEntry).to(equal(@"entry"));
        expect(testResponse.triggerSource).to(equal([SDLTriggerSource KEYBOARD]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPerformInteractionResponse* testResponse = [[SDLPerformInteractionResponse alloc] init];
        
        expect(testResponse.choiceID).to(beNil());
        expect(testResponse.manualTextEntry).to(beNil());
        expect(testResponse.triggerSource).to(beNil());
    });
});

QuickSpecEnd