//
//  SDLRPCRequest.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCRequest.h"

QuickSpecBegin(SDLRPCRequestSpec)

describe(@"Getter/Setter Tests",  ^ {
    it(@"Should set and get correctly", ^ {
        SDLRPCRequest* testRequest = [[SDLRPCRequest alloc] initWithName:@"A Legitimate Request"];
        
        testRequest.correlationID = @14641;
        
        expect(testRequest.correlationID).to(equal(@14641));
    });
});

QuickSpecEnd