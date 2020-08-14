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

        it(@"should set the rpcName and parameterPermissions correctly", ^{
            expect(testPermissionElement.rpcName).to(equal(testRPCName1));
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

        it(@"should copy correctly", ^{
            expect(testPermissionElementCopy).toNot(beIdenticalTo(testPermissionElement));
            expect(testPermissionElementCopy.rpcName).to(equal(testPermissionElement.rpcName));
            expect(testPermissionElementCopy.parameterPermissions).to(equal(testPermissionElement.parameterPermissions));
        });
    });
});


QuickSpecEnd
