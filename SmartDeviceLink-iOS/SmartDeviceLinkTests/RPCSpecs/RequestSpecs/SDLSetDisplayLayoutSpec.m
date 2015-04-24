//
//  SDLSetDisplayLayoutSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetDisplayLayout.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSetDisplayLayoutSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetDisplayLayout* testRequest = [[SDLSetDisplayLayout alloc] init];
        
        testRequest.displayLayout = @"wat";
        
        expect(testRequest.displayLayout).to(equal(@"wat"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_displayLayout:@"wat"},
                                             NAMES_operation_name:NAMES_SetDisplayLayout}} mutableCopy];
        SDLSetDisplayLayout* testRequest = [[SDLSetDisplayLayout alloc] initWithDictionary:dict];
        
        expect(testRequest.displayLayout).to(equal(@"wat"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetDisplayLayout* testRequest = [[SDLSetDisplayLayout alloc] init];
        
        expect(testRequest.displayLayout).to(beNil());
    });
});

QuickSpecEnd