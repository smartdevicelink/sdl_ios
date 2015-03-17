//
//  SDLSetAppIconSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetAppIcon.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSetAppIconSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetAppIcon* testRequest = [[SDLSetAppIcon alloc] init];
        
        testRequest.syncFileName = @"A/File/Name";
        
        expect(testRequest.syncFileName).to(equal(@"A/File/Name"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_syncFileName:@"A/File/Name"},
                                             NAMES_operation_name:NAMES_SetAppIcon}} mutableCopy];
        SDLSetAppIcon* testRequest = [[SDLSetAppIcon alloc] initWithDictionary:dict];
        
        expect(testRequest.syncFileName).to(equal(@"A/File/Name"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetAppIcon* testRequest = [[SDLSetAppIcon alloc] init];
        
        expect(testRequest.syncFileName).to(beNil());
    });
});

QuickSpecEnd