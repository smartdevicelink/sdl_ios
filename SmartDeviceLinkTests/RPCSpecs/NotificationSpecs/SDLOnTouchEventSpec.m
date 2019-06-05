//
//  SDLOnTouchEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnTouchEvent.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTouchEvent.h"
#import "SDLTouchType.h"


QuickSpecBegin(SDLOnTouchEventSpec)

SDLTouchEvent* event = [[SDLTouchEvent alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] init];
        
        testNotification.type = SDLTouchTypeBegin;
        testNotification.event = [@[event] mutableCopy];
        
        expect(testNotification.type).to(equal(SDLTouchTypeBegin));
        expect(testNotification.event).to(equal([@[event] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameType:SDLTouchTypeBegin,
                                                   SDLRPCParameterNameEvent:[@[event] mutableCopy]},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnTouchEvent}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.type).to(equal(SDLTouchTypeBegin));
        expect(testNotification.event).to(equal([@[event] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] init];
        
        expect(testNotification.type).to(beNil());
        expect(testNotification.event).to(beNil());
    });
});

QuickSpecEnd
