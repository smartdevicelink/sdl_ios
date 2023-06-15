//
//  SDLDeleteCommandSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

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
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] initWithDictionary:dict];
        
        expect(testRequest.cmdID).to(equal(@11223344));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] init];
        
        expect(testRequest.cmdID).to(beNil());
    });
});

QuickSpecEnd
