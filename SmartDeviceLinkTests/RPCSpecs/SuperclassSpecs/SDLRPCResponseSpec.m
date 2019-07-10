//
//  SDLRPCResponse.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLResult.h"
#import "SDLRPCResponse.h"


QuickSpecBegin(SDLRPCResponseSpec)

describe(@"Getter/Setter Tests",  ^ {
    it(@"Should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCResponse* response = [[SDLRPCResponse alloc] initWithName:@"A Legitimate Response"];
#pragma clang diagnostic pop
        
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
        NSMutableDictionary* dict = [@{SDLRPCParameterNameResponse:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameSuccess:@YES,
                                                   SDLRPCParameterNameResultCode:SDLRPCParameterNameSuccess,
                                                   SDLRPCParameterNameInfo:@"Test Info"},
                                             SDLRPCParameterNameCorrelationId:@1004,
                                             SDLRPCParameterNameOperationName:SDLRPCParameterNameResponse}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCResponse* testResponse = [[SDLRPCResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testResponse.name).to(equal(SDLRPCParameterNameResponse));
        expect(testResponse.correlationID).to(equal(@1004));
        expect(testResponse.success).to(equal(@YES));
        expect(testResponse.resultCode).to(equal(SDLRPCParameterNameSuccess));
        expect(testResponse.info).to(equal(@"Test Info"));
        
    });
});

QuickSpecEnd
