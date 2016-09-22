//
//  SDLOnDriverDistractionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDriverDistractionState.h"
#import "SDLOnDriverDistraction.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnDriverDistractionSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnDriverDistraction* testNotification = [[SDLOnDriverDistraction alloc] init];
        
        testNotification.state = SDLDriverDistractionStateOn;
        
        expect(testNotification.state).to(equal(SDLDriverDistractionStateOn));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_state:SDLDriverDistractionStateOn},
                                             NAMES_operation_name:NAMES_OnDriverDistraction}} mutableCopy];
        SDLOnDriverDistraction* testNotification = [[SDLOnDriverDistraction alloc] initWithDictionary:dict];
        
        expect(testNotification.state).to(equal(SDLDriverDistractionStateOn));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnDriverDistraction* testNotification = [[SDLOnDriverDistraction alloc] init];
        
        expect(testNotification.state).to(beNil());
    });
});

QuickSpecEnd
