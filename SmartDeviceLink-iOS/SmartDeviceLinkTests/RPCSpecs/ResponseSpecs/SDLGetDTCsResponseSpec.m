//
//  SDLGetDTCsResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetDTCsResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetDTCsResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetDTCsResponse* testResponse = [[SDLGetDTCsResponse alloc] init];
        
        testResponse.ecuHeader = @404;
        testResponse.dtc = [@[@"FFFF", @"FFFE", @"FFFD"] mutableCopy];
        
        expect(testResponse.ecuHeader).to(equal(@404));
        expect(testResponse.dtc).to(equal([@[@"FFFF", @"FFFE", @"FFFD"] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                          @{NAMES_parameters:
                                                @{NAMES_ecuHeader:@404,
                                                  NAMES_dtc:[@[@"FFFF", @"FFFE", @"FFFD"] mutableCopy]},
                                            NAMES_operation_name:NAMES_GetDTCs}} mutableCopy];
        SDLGetDTCsResponse* testResponse = [[SDLGetDTCsResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.ecuHeader).to(equal(@404));
        expect(testResponse.dtc).to(equal([@[@"FFFF", @"FFFE", @"FFFD"] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetDTCsResponse* testResponse = [[SDLGetDTCsResponse alloc] init];
        
        expect(testResponse.ecuHeader).to(beNil());
        expect(testResponse.dtc).to(beNil());
    });
});

QuickSpecEnd