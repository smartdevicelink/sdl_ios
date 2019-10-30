//
//  SDLSeatLocationSpec.m
//  SmartDeviceLinkTests
//
//  Created by standa1 on 7/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSeatLocation.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLSeatLocationSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLGrid *testGird = nil;
    
    beforeEach(^{
        testGird = [[SDLGrid alloc] init];
        testGird.col = @0;
        testGird.row = @0;
        testGird.level = @0;
        testGird.rowspan = @2;
        testGird.colspan = @3;
        testGird.levelspan = @1;
    });

    it(@"Should set and get correctly", ^ {
        SDLSeatLocation *testStruct = [[SDLSeatLocation alloc] init];
        
        testStruct.grid = testGird;
        
        expect(testStruct.grid).to(equal(testGird));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameGrid:testGird} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSeatLocation *testStruct = [[SDLSeatLocation alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.grid).to(equal(testGird));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSeatLocation *testStruct = [[SDLSeatLocation alloc] init];

        expect(testStruct.grid).to(beNil());
    });
});

QuickSpecEnd
