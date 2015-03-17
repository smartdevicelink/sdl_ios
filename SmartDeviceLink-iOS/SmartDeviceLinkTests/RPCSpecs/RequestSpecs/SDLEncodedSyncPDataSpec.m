//
//  SDLEncodedSyncPDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEncodedSyncPData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLEncodedSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
        
		testRequest.data = [@[@2, @2, @2] mutableCopy];

		expect(testRequest.data).to(equal([@[@2, @2, @2] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_data:[@[@2, @2, @2] mutableCopy]},
                                             NAMES_operation_name:NAMES_EncodedSyncPData}} mutableCopy];
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] initWithDictionary:dict];
        
        expect(testRequest.data).to(equal([@[@2, @2, @2] mutableCopy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
        
		expect(testRequest.data).to(beNil());
	});
});

QuickSpecEnd