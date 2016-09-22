//
//  SDLOnTBTClientStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnTBTClientState.h"
#import "SDLNames.h"
#import "SDLTBTState.h"


QuickSpecBegin(SDLOnTBTClientStateSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        testNotification.state = SDLTBTStateEtaRequest;
        
        expect(testNotification.state).to(equal(SDLTBTStateEtaRequest));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_state:SDLTBTStateEtaRequest},
                                             NAMES_operation_name:NAMES_OnTBTClientState}} mutableCopy];
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] initWithDictionary:dict];
        
        expect(testNotification.state).to(equal(SDLTBTStateEtaRequest));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        expect(testNotification.state).to(beNil());
    });
});

QuickSpecEnd
