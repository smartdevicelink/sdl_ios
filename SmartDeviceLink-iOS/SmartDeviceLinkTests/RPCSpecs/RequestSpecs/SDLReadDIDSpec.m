//
//  SDLReadDIDSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLReadDID.h"
#import "SDLNames.h"

QuickSpecBegin(SDLReadDIDSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLReadDID* testRequest = [[SDLReadDID alloc] init];
        
        testRequest.ecuName = @33112;
        testRequest.didLocation = [@[@200, @201, @205] mutableCopy];
        
        expect(testRequest.ecuName).to(equal(@33112));
        expect(testRequest.didLocation).to(equal([@[@200, @201, @205] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_ecuName:@33112,
                                                   NAMES_didLocation:[@[@200, @201, @205] mutableCopy]},
                                             NAMES_operation_name:NAMES_EndAudioPassThru}} mutableCopy];
        SDLReadDID* testRequest = [[SDLReadDID alloc] initWithDictionary:dict];
        
        expect(testRequest.ecuName).to(equal(@33112));
        expect(testRequest.didLocation).to(equal([@[@200, @201, @205] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLReadDID* testRequest = [[SDLReadDID alloc] init];
        
        expect(testRequest.ecuName).to(beNil());
        expect(testRequest.didLocation).to(beNil());
    });
});

QuickSpecEnd