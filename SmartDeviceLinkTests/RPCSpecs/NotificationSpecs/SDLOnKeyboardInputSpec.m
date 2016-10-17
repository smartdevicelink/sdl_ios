//
//  SDLOnKeyboardInputSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardEvent.h"
#import "SDLOnKeyboardInput.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnKeyboardInputSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnKeyboardInput* testNotification = [[SDLOnKeyboardInput alloc] init];
        
        testNotification.event = SDLKeyboardEventSubmitted;
        testNotification.data = @"qwertyg";
        
        expect(testNotification.event).to(equal(SDLKeyboardEventSubmitted));
        expect(testNotification.data).to(equal(@"qwertyg"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{SDLNameEvent:SDLKeyboardEventSubmitted,
                                                   SDLNameData:@"qwertyg"},
                                             SDLNameOperationName:SDLNameOnKeyboardInput}} mutableCopy];
        SDLOnKeyboardInput* testNotification = [[SDLOnKeyboardInput alloc] initWithDictionary:dict];
        
        expect(testNotification.event).to(equal(SDLKeyboardEventSubmitted));
        expect(testNotification.data).to(equal(@"qwertyg"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnKeyboardInput* testNotification = [[SDLOnKeyboardInput alloc] init];
        
        expect(testNotification.event).to(beNil());
        expect(testNotification.data).to(beNil());
    });
});

QuickSpecEnd
