//
//  SDLOnCommandSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLOnCommand.h"
#import "SDLTriggerSource.h"

QuickSpecBegin(SDLOnCommandSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnCommand* testNotification = [[SDLOnCommand alloc] init];
        
        testNotification.cmdID = @5676544;
        testNotification.triggerSource = [SDLTriggerSource KEYBOARD];
        
        expect(testNotification.cmdID).to(equal(@5676544));
        expect(testNotification.triggerSource).to(equal([SDLTriggerSource KEYBOARD]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_cmdID:@5676544,
                                                   NAMES_triggerSource:[SDLTriggerSource KEYBOARD]},
                                             NAMES_operation_name:NAMES_OnCommand}} mutableCopy];
        SDLOnCommand* testNotification = [[SDLOnCommand alloc] initWithDictionary:dict];
        
        expect(testNotification.cmdID).to(equal(@5676544));
        expect(testNotification.triggerSource).to(equal([SDLTriggerSource KEYBOARD]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnCommand* testNotification = [[SDLOnCommand alloc] init];
        
        expect(testNotification.cmdID).to(beNil());
        expect(testNotification.triggerSource).to(beNil());
    });
});

QuickSpecEnd