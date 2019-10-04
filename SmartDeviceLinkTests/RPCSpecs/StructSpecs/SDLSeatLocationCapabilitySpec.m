//
//  SDLSeatLocationCapabilitySpec.m
//  SmartDeviceLinkTests
//
//  Created by standa1 on 7/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSeatLocationCapability.h"
#import "SDLGrid.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLSeatLocationCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLGrid *testGird = nil;
    __block SDLSeatLocation *driverSeat = nil;
    
    beforeEach(^{
        testGird = [[SDLGrid alloc] init];
        testGird.col = @0;
        testGird.row = @0;
        testGird.level = @0;
        testGird.rowspan = @2;
        testGird.colspan = @3;
        testGird.levelspan = @1;
        driverSeat = [[SDLSeatLocation alloc] init];
        driverSeat.grid = testGird;
    });
    
    it(@"Should set and get correctly", ^ {
        SDLSeatLocationCapability *testStruct = [[SDLSeatLocationCapability alloc] init];
        
        testStruct.cols = @3;
        testStruct.rows = @2;
        testStruct.levels = @1;
        testStruct.seats = @[driverSeat];

        expect(testStruct.cols).to(equal(@3));
        expect(testStruct.rows).to(equal(@2));
        expect(testStruct.levels).to(equal(@1));
        expect(testStruct.seats).to(equal(@[driverSeat]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{
                                       SDLRPCParameterNameRows:@2,
                                       SDLRPCParameterNameColumns:@3,
                                       SDLRPCParameterNameLevels:@1,
                                       SDLRPCParameterNameSeats:@[driverSeat]} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSeatLocationCapability *testStruct = [[SDLSeatLocationCapability alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.cols).to(equal(@3));
        expect(testStruct.rows).to(equal(@2));
        expect(testStruct.levels).to(equal(@1));
        expect(testStruct.seats).to(equal(@[driverSeat]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        SDLSeatLocationCapability *testStruct = [[SDLSeatLocationCapability alloc] initWithSeats:@[driverSeat] cols:@3 rows:@2 levels:@1];
        
        expect(testStruct.cols).to(equal(@3));
        expect(testStruct.rows).to(equal(@2));
        expect(testStruct.levels).to(equal(@1));
        expect(testStruct.seats).to(equal(@[driverSeat]));
    });

    
    it(@"Should return nil if not set", ^ {
        SDLSeatLocationCapability *testStruct = [[SDLSeatLocationCapability alloc] init];
        
        expect(testStruct.cols).to(beNil());
        expect(testStruct.rows).to(beNil());
        expect(testStruct.levels).to(beNil());
        expect(testStruct.seats).to(beNil());
    });
});

QuickSpecEnd
