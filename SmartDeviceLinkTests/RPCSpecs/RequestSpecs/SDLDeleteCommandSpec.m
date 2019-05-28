//
//  SDLDeleteCommandSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteCommand.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLDeleteCommandSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] init];
        
        testRequest.cmdID = @11223344;
        
        expect(testRequest.cmdID).to(equal(@11223344));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameCommandId:@11223344},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameDeleteCommand}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.cmdID).to(equal(@11223344));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] init];
        
        expect(testRequest.cmdID).to(beNil());
    });
});

QuickSpecEnd
