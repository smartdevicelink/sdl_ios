//
//  SDLOnTouchEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnTouchEvent.h"
#import "SDLNames.h"
#import "SDLTouchEvent.h"
#import "SDLTouchType.h"


QuickSpecBegin(SDLOnTouchEventSpec)

SDLTouchEvent* event = [[SDLTouchEvent alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] init];
        
        testNotification.type = [SDLTouchType BEGIN];
        testNotification.event = [@[event] mutableCopy];
        
        expect(testNotification.type).to(equal([SDLTouchType BEGIN]));
        expect(testNotification.event).to(equal([@[event] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_type:[SDLTouchType BEGIN],
                                                   NAMES_event:[@[event] mutableCopy]},
                                             NAMES_operation_name:NAMES_OnTouchEvent}} mutableCopy];
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] initWithDictionary:dict];
        
        expect(testNotification.type).to(equal([SDLTouchType BEGIN]));
        expect(testNotification.event).to(equal([@[event] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] init];
        
        expect(testNotification.type).to(beNil());
        expect(testNotification.event).to(beNil());
    });
});

QuickSpecEnd