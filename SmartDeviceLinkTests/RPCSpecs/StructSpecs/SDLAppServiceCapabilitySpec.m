//
//  SDLAppServiceCapabilitySpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceCapability.h"
#import "SDLAppServiceRecord.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLAppServiceCapabilitySpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLServiceUpdateReason testUpdateReason = nil;
    __block SDLAppServiceRecord *testUpdatedAppServiceRecord = nil;

    beforeEach(^{
        testUpdateReason = SDLServiceUpdateReasonActivated;
        testUpdatedAppServiceRecord = [[SDLAppServiceRecord alloc] initWithDictionary:@{SDLRPCParameterNameServiceID:@"1234", SDLRPCParameterNameServicePublished:@YES}];
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceCapability *testStruct = [[SDLAppServiceCapability alloc] init];
        testStruct.updateReason = testUpdateReason;
        testStruct.updatedAppServiceRecord = testUpdatedAppServiceRecord;

        expect(testStruct.updateReason).to(equal(testUpdateReason));
        expect(testStruct.updatedAppServiceRecord).to(equal(testUpdatedAppServiceRecord));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameUpdateReason:testUpdateReason,
                               SDLRPCParameterNameUpdatedAppServiceRecord:testUpdatedAppServiceRecord
                               };
        SDLAppServiceCapability *testStruct = [[SDLAppServiceCapability alloc] initWithDictionary:dict];

        expect(testStruct.updateReason).to(equal(testUpdateReason));
        expect(testStruct.updatedAppServiceRecord).to(equal(testUpdatedAppServiceRecord));
    });

    it(@"Should get correctly when initialized with initWithUpdatedAppServiceRecord:", ^{
        SDLAppServiceCapability *testStruct = [[SDLAppServiceCapability alloc] initWithUpdatedAppServiceRecord:testUpdatedAppServiceRecord];

        expect(testStruct.updateReason).to(beNil());
        expect(testStruct.updatedAppServiceRecord).to(equal(testUpdatedAppServiceRecord));
    });

    it(@"Should get correctly when initialized with initWithUpdateReason:updatedAppServiceRecord", ^{
        SDLAppServiceCapability *testStruct = [[SDLAppServiceCapability alloc] initWithUpdateReason:testUpdateReason updatedAppServiceRecord:testUpdatedAppServiceRecord];

        expect(testStruct.updateReason).to(equal(testUpdateReason));
        expect(testStruct.updatedAppServiceRecord).to(equal(testUpdatedAppServiceRecord));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceCapability *testStruct = [[SDLAppServiceCapability alloc] init];

        expect(testStruct.updateReason).to(beNil());
        expect(testStruct.updatedAppServiceRecord).to(beNil());
    });
});

QuickSpecEnd
