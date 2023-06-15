//
//  SDLOnTBTClientStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLOnTBTClientState.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTBTState.h"


QuickSpecBegin(SDLOnTBTClientStateSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        testNotification.state = SDLTBTStateETARequest;
        
        expect(testNotification.state).to(equal(SDLTBTStateETARequest));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameState:SDLTBTStateETARequest},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnTBTClientState}} mutableCopy];
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] initWithDictionary:dict];
        
        expect(testNotification.state).to(equal(SDLTBTStateETARequest));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        expect(testNotification.state).to(beNil());
    });
});

QuickSpecEnd
