//
//  SDLScrollableMessageSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLScrollableMessage.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameScrollableMessageBody:@"thatmessagebody",
                                                                   SDLRPCParameterNameTimeout:@9182,
                                                                   SDLRPCParameterNameSoftButtons:[@[button] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameScrollableMessage}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLScrollableMessage* testRequest = [[SDLScrollableMessage alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
