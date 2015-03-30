//
//  SDLScrollableMessageSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLScrollableMessage.h"
#import "SDLSoftButton.h"
#import "SDLNames.h"

QuickSpecBegin(SDLScrollableMessageSpec)

SDLSoftButton* button = [[SDLSoftButton alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLScrollableMessage* testRequest = [[SDLScrollableMessage alloc] init];
        
        testRequest.scrollableMessageBody = @"thatmessagebody";
        testRequest.timeout = @9182;
        testRequest.softButtons = [@[button] mutableCopy];
        
        expect(testRequest.scrollableMessageBody).to(equal(@"thatmessagebody"));
        expect(testRequest.timeout).to(equal(@9182));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_scrollableMessageBody:@"thatmessagebody",
                                                   NAMES_timeout:@9182,
                                                   NAMES_softButtons:[@[button] mutableCopy]},
                                             NAMES_operation_name:NAMES_ScrollableMessage}} mutableCopy];
        SDLScrollableMessage* testRequest = [[SDLScrollableMessage alloc] initWithDictionary:dict];
        
        expect(testRequest.scrollableMessageBody).to(equal(@"thatmessagebody"));
        expect(testRequest.timeout).to(equal(@9182));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLScrollableMessage* testRequest = [[SDLScrollableMessage alloc] init];
        
        expect(testRequest.scrollableMessageBody).to(beNil());
        expect(testRequest.timeout).to(beNil());
        expect(testRequest.softButtons).to(beNil());
    });
});

QuickSpecEnd