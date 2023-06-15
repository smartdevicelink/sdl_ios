//
//  SDLEncodedSyncPDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLEncodedSyncPData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLEncodedSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
#pragma clang diagnostic pop
        
		testRequest.data = [@[@"2", @"2", @"2"] mutableCopy];

		expect(testRequest.data).to(equal([@[@"2", @"2", @"2"] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                    @{SDLRPCParameterNameParameters:
                                                          @{SDLRPCParameterNameData:@[@"2", @"2", @"2"]},
                                                      SDLRPCParameterNameOperationName:SDLRPCFunctionNameEncodedSyncPData}};
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.data).to(equal([@[@"2", @"2", @"2"] mutableCopy]));
    });

    it(@"Should return nil if not set", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
#pragma clang diagnostic pop
        
		expect(testRequest.data).to(beNil());
	});
});

QuickSpecEnd
