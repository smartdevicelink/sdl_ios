//
//  SDLRPCRequest.m
//  SmartDeviceLink-iOS
//
//  Created by Jacob Keeler on 2/12/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

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