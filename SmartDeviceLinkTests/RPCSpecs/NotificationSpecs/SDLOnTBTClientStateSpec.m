//
//  SDLOnTBTClientStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.state).to(equal(SDLTBTStateETARequest));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        expect(testNotification.state).to(beNil());
    });
});

QuickSpecEnd
