//
//  SDLDeleteCommandSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteCommand.h"
#import "SDLNames.h"

QuickSpecBegin(SDLDeleteCommandSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] init];
        
        testRequest.cmdID = @11223344;
        
        expect(testRequest.cmdID).to(equal(@11223344));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_cmdID:@11223344},
                                             NAMES_operation_name:NAMES_DeleteCommand}} mutableCopy];
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] initWithDictionary:dict];
        
        expect(testRequest.cmdID).to(equal(@11223344));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDeleteCommand* testRequest = [[SDLDeleteCommand alloc] init];
        
        expect(testRequest.cmdID).to(beNil());
    });
});

QuickSpecEnd