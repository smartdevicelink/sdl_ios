//
//  SDLPermissionElementSpec.m
//  SmartDeviceLinkTests
//
//  Created by James Lapinski on 6/24/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLParameterPermissions.h"
#import "SDLPermissionElement.h"

QuickSpecBegin(SDLPermissionElementSpec)

describe(@"A permission element", ^{
    __block NSString *testRPCName1 = nil;
    __block NSArray<NSString *> *parameterPermissions = nil;
    __block NSString *testParameterRPCName = nil;

    beforeEach(^{
        testRPCName1 = @"testRPCName1";
        testParameterRPCName = @"testParameterRPCName";
        parameterPermissions = @[testParameterRPCName];
    });

    describe(@"it should initialize correctly", ^{
        __block SDLPermissionElement *testPermissionElement = nil;

        beforeEach(^{
            testPermissionElement = [[SDLPermissionElement alloc] initWithRPCName:testRPCName1 parameterPermissions:parameterPermissions];
        });

        it(@"should set the rpcName correctly", ^{
            expect(testPermissionElement.rpcName).to(equal(testRPCName1));
        });

        it(@"should set the parameterPermissions correctly", ^{
            expect(testPermissionElement.parameterPermissions).to(equal(parameterPermissions));
        });
    });

    describe(@"copying a permission element", ^{
        __block SDLPermissionElement *testPermissionElement = nil;
        __block SDLPermissionElement *testPermissionElementCopy = nil;

        beforeEach(^{
            testPermissionElement = [[SDLPermissionElement alloc] initWithRPCName:testRPCName1 parameterPermissions:parameterPermissions];
            testPermissionElementCopy = [testPermissionElement copy];
        });

        it(@"should say copied filters are not the same instance", ^{
            expect(testPermissionElementCopy).toNot(beIdenticalTo(testPermissionElement));
        });

        it(@"should copy the rpc name correctly", ^{
            expect(testPermissionElementCopy.rpcName).to(equal(testPermissionElement.rpcName));
        });

        it(@"should copy the parameter permissions correctly", ^{
            expect(testPermissionElementCopy.parameterPermissions).to(equal(testPermissionElement.parameterPermissions));
        });
    });
});


QuickSpecEnd
