//
//  SDLDeleteFileResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFileResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLDeleteFileResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteFileResponse* testResponse = [[SDLDeleteFileResponse alloc] init];
        
        testResponse.spaceAvailable = @0;
        
        expect(testResponse.spaceAvailable).to(equal(@0));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                           @{NAMES_parameters:
                                                 @{NAMES_spaceAvailable:@0},
                                             NAMES_operation_name:NAMES_DeleteFile}} mutableCopy];
        SDLDeleteFileResponse* testResponse = [[SDLDeleteFileResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.spaceAvailable).to(equal(@0));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDeleteFileResponse* testResponse = [[SDLDeleteFileResponse alloc] init];
        
        expect(testResponse.spaceAvailable).to(beNil());
    });
});

QuickSpecEnd