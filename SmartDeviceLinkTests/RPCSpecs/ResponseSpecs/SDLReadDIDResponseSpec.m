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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameResponse:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameDIDResult:[@[result] mutableCopy]},
                                                             SDLNameOperationName:SDLNameReadDID}} mutableCopy];
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.didResult).to(equal([@[result] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] init];
        
        expect(testResponse.didResult).to(beNil());
    });
});

QuickSpecEnd
