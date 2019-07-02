//
//  SDLEncodedSyncPDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEncodedSyncPData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLEncodedSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
        
		testRequest.data = [@[@"2", @"2", @"2"] mutableCopy];

		expect(testRequest.data).to(equal([@[@"2", @"2", @"2"] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameData:[@[@"2", @"2", @"2"] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameEncodedSyncPData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.data).to(equal([@[@"2", @"2", @"2"] mutableCopy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
        
		expect(testRequest.data).to(beNil());
	});
});

QuickSpecEnd
