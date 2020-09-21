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
const float range = 23.0f;
SDLFuelType type = SDLFuelTypeDiesel;
SDLComponentVolumeStatus levelState = SDLComponentVolumeStatusAlert;
SDLCapacityUnit capacityUnit = SDLCapacityUnitKilowatthours;

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] init];
        testStruct.type = type;
        testStruct.range = @(range);
        testStruct.level = @(fuelLevel);
        testStruct.levelState = levelState;
        testStruct.capacity = @(fuelCapacity);
        testStruct.capacityUnit = capacityUnit;
    
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.type).to(equal(type));
            expect(testStruct.range).to(equal(@(range)));
            expect(testStruct.level).to(equal(fuelLevel));
            expect(testStruct.levelState).to(equal(levelState));
            expect(testStruct.capacity).to(equal(fuelCapacity));
            expect(testStruct.capacityUnit).to(equal(capacityUnit));
        });
    });

    context(@"should get correctly when initialized with dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameType:type,
                            SDLRPCParameterNameRange:@(range),
                            SDLRPCParameterNameLevel:@(fuelLevel),
                            SDLRPCParameterNameLevelState:levelState,
                            SDLRPCParameterNameCapacity:@(fuelCapacity),
                            SDLRPCParameterNameCapacityUnit:capacityUnit
                                };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.type).to(equal(type));
            expect(testStruct.range).to(equal(@(range)));
            expect(testStruct.level).to(equal(fuelLevel));
            expect(testStruct.levelState).to(equal(levelState));
            expect(testStruct.capacity).to(equal(fuelCapacity));
            expect(testStruct.capacityUnit).to(equal(capacityUnit));
        });
    });

    context(@"init", ^{
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.type).to(beNil());
            expect(testStruct.range).to(beNil());
            expect(testStruct.level).to(beNil());
            expect(testStruct.levelState).to(beNil());
            expect(testStruct.capacity).to(beNil());
            expect(testStruct.capacityUnit).to(beNil());
        });
    });

    context(@"initWithType:range:level:levelState:capacity:capacityUnit:", ^{
        SDLFuelRange *testStruct = [[SDLFuelRange alloc] initWithType:type range:range level:fuelLevel levelState:levelState capacity:fuelCapacity capacityUnit:capacityUnit];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.type).to(equal(type));
            expect(testStruct.range).to(equal(@(range)));
            expect(testStruct.level).to(equal(fuelLevel));
            expect(testStruct.levelState).to(equal(levelState));
            expect(testStruct.capacity).to(equal(fuelCapacity));
            expect(testStruct.capacityUnit).to(equal(capacityUnit));
        });
    });
});

QuickSpecEnd
