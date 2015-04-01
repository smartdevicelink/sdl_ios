//
//  SDLMyKeySpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMyKey.h"
#import "SDLNames.h"
#import "SDLVehicleDataStatus.h"


QuickSpecBegin(SDLMyKeySpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLMyKey* testStruct = [[SDLMyKey alloc] init];
        
        testStruct.e911Override = [SDLVehicleDataStatus OFF];
        
        expect(testStruct.e911Override).to(equal([SDLVehicleDataStatus OFF]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_e911Override:[SDLVehicleDataStatus ON]} mutableCopy];
        SDLMyKey* testStruct = [[SDLMyKey alloc] initWithDictionary:dict];
        
        expect(testStruct.e911Override).to(equal([SDLVehicleDataStatus ON]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLMyKey* testStruct = [[SDLMyKey alloc] init];
        
        expect(testStruct.e911Override).to(beNil());
    });
});

QuickSpecEnd