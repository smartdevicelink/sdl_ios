//
//  SDLFuelRangeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFuelRange.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLFuelRangeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] init];

        testStruct.type = SDLFuelTypeDiesel;
        testStruct.range = @45;

        expect(testStruct.type).to(equal(SDLFuelTypeDiesel));
        expect(testStruct.range).to(equal(@45));
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameType:SDLFuelTypeLPG,
                                SDLRPCParameterNameRange:@23
                                };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.type).to(equal(SDLFuelTypeLPG));
        expect(testStruct.range).to(equal(@23));
    });

    it(@"Should return nil if not set", ^ {
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] init];

        expect(testStruct.type).to(beNil());
        expect(testStruct.range).to(beNil());
    });
});

QuickSpecEnd
