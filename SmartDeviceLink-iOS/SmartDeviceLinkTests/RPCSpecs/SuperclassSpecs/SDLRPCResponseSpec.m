//
//  SDLRPCResponse.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLResult.h"
#import "SDLRPCResponse.h"


QuickSpecBegin(SDLRPCResponseSpec)

describe(@"Getter/Setter Tests",  ^ {
    it(@"Should set and get correctly", ^ {
        SDLRPCResponse* response = [[SDLRPCResponse alloc] initWithName:@"A Legitimate Response"];
        
        response.correlationID = @14641;
        response.success = @YES;
        response.resultCode = [SDLResult IGNORED];
        response.info = @"It has been done";
        
        expect(response.correlationID).to(equal(@14641));
        expect(response.success).to(equal(@YES));
        expect(response.resultCode).to(equal([SDLResult IGNORED]));
        expect(response.info).to(equal(@"It has been done"));
    });
});

QuickSpecEnd