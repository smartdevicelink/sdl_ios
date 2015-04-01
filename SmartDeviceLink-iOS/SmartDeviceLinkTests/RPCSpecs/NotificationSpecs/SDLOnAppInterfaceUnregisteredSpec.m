//
//  SDLOnAppInterfaceUnregisteredSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppInterfaceUnregisteredReason.h"
#import "SDLOnAppInterfaceUnregistered.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnAppInterfaceUnregisteredSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnAppInterfaceUnregistered* testNotification = [[SDLOnAppInterfaceUnregistered alloc] init];
        
        testNotification.reason = [SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED];
        
        expect(testNotification.reason).to(equal([SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_reason:[SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED]},
                                             NAMES_operation_name:NAMES_OnAppInterfaceUnregistered}} mutableCopy];
        SDLOnAppInterfaceUnregistered* testNotification = [[SDLOnAppInterfaceUnregistered alloc] initWithDictionary:dict];
        
        expect(testNotification.reason).to(equal([SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnAppInterfaceUnregistered* testNotification = [[SDLOnAppInterfaceUnregistered alloc] init];
        
        expect(testNotification.reason).to(beNil());
    });
});

QuickSpecEnd