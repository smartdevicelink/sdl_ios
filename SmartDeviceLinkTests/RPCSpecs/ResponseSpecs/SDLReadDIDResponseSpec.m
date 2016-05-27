//
//  SDLReadDIDResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLReadDIDResponse.h"
#import "SDLDIDResult.h"
#import "SDLNames.h"

QuickSpecBegin(SDLReadDIDResponseSpec)

SDLDIDResult* result = [[SDLDIDResult alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] init];
        
        testResponse.didResult = [@[result] mutableCopy];
        
        expect(testResponse.didResult).to(equal([@[result] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                           @{NAMES_parameters:
                                                 @{NAMES_didResult:[@[result] mutableCopy]},
                                             NAMES_operation_name:NAMES_ReadDID}} mutableCopy];
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.didResult).to(equal([@[result] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] init];
        
        expect(testResponse.didResult).to(beNil());
    });
});

QuickSpecEnd