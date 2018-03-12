//
//  SDLFuelRangeSpec.m
//  SmartDeviceLink-iOS
//
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLFuelRange.h"
#import "SDLFuelType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLFuelRangeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLFuelRange* testStruct = [[SDLFuelRange alloc] init];

        testStruct.type = SDLFuelTypeGasoline;
        testStruct.range = @12;

        expect(testStruct.type).to(equal(SDLFuelTypeGasoline));
        expect(testStruct.range).to(equal(@12));

    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameType:SDLFuelTypeGasoline,
                                       SDLNameRange:@12} mutableCopy];
        SDLFuelRange* testStruct = [[SDLFuelRange alloc] initWithDictionary:dict];

        expect(testStruct.type).to(equal(SDLFuelTypeGasoline));
        expect(testStruct.range).to(equal(@12));
    });

    it(@"Should return nil if not set", ^ {
        SDLFuelRange* testStruct = [[SDLFuelRange alloc] init];

        expect(testStruct.type).to(beNil());
        expect(testStruct.range).to(beNil());
    });
});

QuickSpecEnd
