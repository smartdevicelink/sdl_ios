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
const float fuelLevel = 123.45f;
const float fuelCapacity = 34.56f;
const float range = 23.0;

describe(@"getter/setter tests", ^{
    it(@"should set and get correctly", ^{
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] init];

        testStruct.type = SDLFuelTypeDiesel;
        testStruct.range = @(range);
        testStruct.level = @(fuelLevel);
        testStruct.levelState = SDLComponentVolumeStatusAlert;
        testStruct.capacity = @(fuelCapacity);
        testStruct.capacityUnit = SDLCapacityUnitKilowatthours;

        expect(testStruct.type).to(equal(SDLFuelTypeDiesel));
        expect(testStruct.range).to(equal(@(range)));
        expect(testStruct.level).to(equal(fuelLevel));
        expect(testStruct.levelState).to(equal(SDLComponentVolumeStatusAlert));
        expect(testStruct.capacity).to(equal(fuelCapacity));
        expect(testStruct.capacityUnit).to(equal(SDLCapacityUnitKilowatthours));

    });

    it(@"should get correctly when initialized with dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameType:SDLFuelTypeLPG,
                            SDLRPCParameterNameRange:@(range),
                            SDLRPCParameterNameLevel:@(fuelLevel),
                            SDLRPCParameterNameLevelState:SDLComponentVolumeStatusAlert,
                            SDLRPCParameterNameCapacity:@(fuelCapacity),
                            SDLRPCParameterNameCapacityUnit:SDLCapacityUnitKilowatthours
                                };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.type).to(equal(SDLFuelTypeLPG));
        expect(testStruct.range).to(equal(@(range)));
        expect(testStruct.level).to(equal(fuelLevel));
        expect(testStruct.levelState).to(equal(SDLComponentVolumeStatusAlert));
        expect(testStruct.capacity).to(equal(fuelCapacity));
        expect(testStruct.capacityUnit).to(equal(SDLCapacityUnitKilowatthours));
    });

    it(@"expect all properties to be nil", ^{
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] init];

        expect(testStruct.type).to(beNil());
        expect(testStruct.range).to(beNil());
        expect(testStruct.level).to(beNil());
        expect(testStruct.levelState).to(beNil());
        expect(testStruct.capacity).to(beNil());
        expect(testStruct.capacityUnit).to(beNil());
    });

    context(@"initWithType:range:level:levelState:capacity:capacityUnit:", ^{
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] initWithType:SDLFuelTypeLPG range:range level:fuelLevel levelState:SDLComponentVolumeStatusAlert capacity:fuelCapacity capacityUnit:SDLCapacityUnitKilowatthours];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.type).to(equal(SDLFuelTypeLPG));
            expect(testStruct.range).to(equal(@(range)));
            expect(testStruct.level).to(equal(fuelLevel));
            expect(testStruct.levelState).to(equal(SDLComponentVolumeStatusAlert));
            expect(testStruct.capacity).to(equal(fuelCapacity));
            expect(testStruct.capacityUnit).to(equal(SDLCapacityUnitKilowatthours));
        });
    });
});

QuickSpecEnd
