//
//  SDLOnDriverDistractionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDriverDistractionState.h"
#import "SDLOnDriverDistraction.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnDriverDistractionSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnDriverDistraction* testNotification = [[SDLOnDriverDistraction alloc] init];
        
        testNotification.state = SDLDriverDistractionStateOn;
        
        expect(testNotification.state).to(equal(SDLDriverDistractionStateOn));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameState:SDLDriverDistractionStateOn},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnDriverDistraction}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnDriverDistraction* testNotification = [[SDLOnDriverDistraction alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.state).to(equal(SDLDriverDistractionStateOn));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnDriverDistraction* testNotification = [[SDLOnDriverDistraction alloc] init];
        
        expect(testNotification.state).to(beNil());
    });
});

QuickSpecEnd
