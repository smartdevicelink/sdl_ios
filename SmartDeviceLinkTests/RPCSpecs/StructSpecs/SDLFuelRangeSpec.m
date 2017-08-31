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
        
        testStruct.fuelType = SDLFuelTypeGasoline;
        testStruct.fuelRange = @12.0;

        expect(testStruct.fuelType).to(equal(SDLFuelTypeGasoline));
        expect(testStruct.fuelRange).to(equal(@12.0));

    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameFuelType:SDLFuelTypeGasoline,
                                       SDLNameFuelRange:@12.0} mutableCopy];
        SDLFuelRange* testStruct = [[SDLFuelRange alloc] initWithDictionary:dict];
        
        expect(testStruct.fuelType).to(equal(SDLFuelTypeGasoline));
        expect(testStruct.fuelRange).to(equal(@12.0));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLFuelRange* testStruct = [[SDLFuelRange alloc] init];
        
        expect(testStruct.fuelType).to(beNil());
        expect(testStruct.fuelRange).to(beNil());
    });
});

QuickSpecEnd
