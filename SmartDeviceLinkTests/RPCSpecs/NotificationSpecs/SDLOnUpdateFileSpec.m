//
//  SDLOnUpdateFileSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 7/30/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLOnUpdateFile.h"

QuickSpecBegin(SDLOnUpdateFileSpec)

__block SDLOnUpdateFile *testRPC = nil;
__block NSString *testFileName = nil;

beforeEach(^{
    testFileName = @"test file name";
});

describe(@"when initializing with init", ^{
    beforeEach(^{
        testRPC = [[SDLOnUpdateFile alloc] init];
    });

    it(@"should have no data", ^{
        expect(testRPC.fileName).to(beNil());
    });

    describe(@"when getting/setting parameters", ^{
        beforeEach(^{
            testRPC.fileName = testFileName;
        });

        it(@"should properly get/set the data", ^{
            expect(testRPC.fileName).to(equal(testFileName));
        });
    });
});

describe(@"when initializing with a dictionary", ^{
    beforeEach(^{
        NSDictionary *testDict = @{
            SDLRPCParameterNameNotification: @{
                SDLRPCParameterNameParameters: @{
                    SDLRPCParameterNameFileName: testFileName
                }
            }
        };

        testRPC = [[SDLOnUpdateFile alloc] initWithDictionary:testDict];
    });

    it(@"should properly get/set the data", ^{
        expect(testRPC.fileName).to(equal(testFileName));
    });
});

describe(@"when initializing with initWithFileName:", ^{
    beforeEach(^{
        testRPC = [[SDLOnUpdateFile alloc] initWithFileName:testFileName];
    });

    it(@"should properly get/set the data", ^{
        expect(testRPC.fileName).to(equal(testFileName));
    });
});

QuickSpecEnd
