//
//  SDLRPCResponse.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLResult.h"
#import "SDLRPCResponse.h"


QuickSpecBegin(SDLRPCResponseSpec)

describe(@"Getter/Setter Tests",  ^ {
    it(@"Should set and get correctly", ^ {
        SDLRPCResponse* response = [[SDLRPCResponse alloc] initWithName:@"A Legitimate Response"];
        
        response.correlationID = @14641;
        response.success = @YES;
        response.resultCode = SDLResultIgnored;
        response.info = @"It has been done";
        
        expect(response.correlationID).to(equal(@14641));
        expect(response.success).to(equal(@YES));
        expect(response.resultCode).to(equal(SDLResultIgnored));
        expect(response.info).to(equal(@"It has been done"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameResponse:
                                           @{SDLNameParameters:
                                                 @{SDLNameSuccess:@YES,
                                                   SDLNameResultCode:SDLNameSuccess,
                                                   SDLNameInfo:@"Test Info"},
                                             SDLNameCorrelationId:@1004,
                                             SDLNameOperationName:SDLNameResponse}} mutableCopy];
        SDLRPCResponse* testResponse = [[SDLRPCResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.getFunctionName).to(equal(SDLNameResponse));
        expect(testResponse.correlationID).to(equal(@1004));
        expect(testResponse.success).to(equal(@YES));
        expect(testResponse.resultCode).to(equal(SDLNameSuccess));
        expect(testResponse.info).to(equal(@"Test Info"));
        
    });
});

QuickSpecEnd
