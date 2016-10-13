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
        
        testNotification.reason = SDLAppInterfaceUnregisteredReasonAppUnauthorized;
        
        expect(testNotification.reason).to(equal(SDLAppInterfaceUnregisteredReasonAppUnauthorized));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{SDLNameReason:SDLAppInterfaceUnregisteredReasonAppUnauthorized},
                                             SDLNameOperationName:SDLNameOnAppInterfaceUnregistered}} mutableCopy];
        SDLOnAppInterfaceUnregistered* testNotification = [[SDLOnAppInterfaceUnregistered alloc] initWithDictionary:dict];
        
        expect(testNotification.reason).to(equal(SDLAppInterfaceUnregisteredReasonAppUnauthorized));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnAppInterfaceUnregistered* testNotification = [[SDLOnAppInterfaceUnregistered alloc] init];
        
        expect(testNotification.reason).to(beNil());
    });
});

QuickSpecEnd
