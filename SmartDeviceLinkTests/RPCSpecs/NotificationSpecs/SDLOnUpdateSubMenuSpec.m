//
//  SDLOnUpdateSubMenuSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 7/30/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLOnUpdateSubMenu.h"

QuickSpecBegin(SDLOnUpdateSubMenuSpec)

__block SDLOnUpdateSubMenu *testRPC = nil;
__block UInt32 testMenuID = 32;
__block NSNumber<SDLBool> *testUpdateSubCells = @YES;

describe(@"when initializing with init", ^{
    beforeEach(^{
        testRPC = [[SDLOnUpdateSubMenu alloc] init];
    });

    it(@"should have no data", ^{
        expect(testRPC.menuID).to(beFalsy());
        expect(testRPC.updateSubCells).to(beFalsy());
    });

    describe(@"when getting/setting parameters", ^{
        beforeEach(^{
            testRPC.menuID = @(testMenuID);
            testRPC.updateSubCells = testUpdateSubCells;
        });

        it(@"should properly get/set the data", ^{
            expect(testRPC.menuID).to(equal(@(testMenuID)));
            expect(testRPC.updateSubCells).to(equal(testUpdateSubCells));
        });
    });
});

describe(@"when initializing with a dictionary", ^{
    beforeEach(^{
        NSDictionary *testDict = @{
            SDLRPCParameterNameNotification: @{
                SDLRPCParameterNameParameters: @{
                    SDLRPCParameterNameMenuID: @(testMenuID),
                    SDLRPCParameterNameUpdateSubCells: testUpdateSubCells
                }
            }
        };

        testRPC = [[SDLOnUpdateSubMenu alloc] initWithDictionary:testDict];
    });

    it(@"should properly get/set the data", ^{
        expect(testRPC.menuID).to(equal(@(testMenuID)));
        expect(testRPC.updateSubCells).to(equal(testUpdateSubCells));
    });
});

describe(@"when initializing with initWithMenuID:", ^{
    beforeEach(^{
        testRPC = [[SDLOnUpdateSubMenu alloc] initWithMenuID:testMenuID];
    });

    it(@"should properly get/set the data", ^{
        expect(testRPC.menuID).to(equal(@(testMenuID)));
        expect(testRPC.updateSubCells).to(beNil());
    });
});

describe(@"when initializing with initWithMenuID:updateSubCells:", ^{
    beforeEach(^{
        testRPC = [[SDLOnUpdateSubMenu alloc] initWithMenuID:testMenuID updateSubCells:testUpdateSubCells];
    });

    it(@"should properly get/set the data", ^{
        expect(testRPC.menuID).to(equal(@(testMenuID)));
        expect(testRPC.updateSubCells).to(equal(testUpdateSubCells));
    });
});

QuickSpecEnd
