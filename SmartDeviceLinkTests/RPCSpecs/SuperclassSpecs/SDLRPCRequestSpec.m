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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCRequest* testRequest = [[SDLRPCRequest alloc] initWithName:@"A Legitimate Request"];
#pragma clang diagnostic pop
        
        testRequest.correlationID = @14641;
        
        expect(testRequest.correlationID).to(equal(@14641));
    });
});

QuickSpecEnd
