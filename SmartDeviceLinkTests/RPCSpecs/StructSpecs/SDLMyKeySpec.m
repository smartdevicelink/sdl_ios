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
        
        testStruct.e911Override = SDLVehicleDataStatusOff;
        
        expect(testStruct.e911Override).to(equal(SDLVehicleDataStatusOff));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameE911Override:SDLVehicleDataStatusOn} mutableCopy];
        SDLMyKey* testStruct = [[SDLMyKey alloc] initWithDictionary:dict];
        
        expect(testStruct.e911Override).to(equal(SDLVehicleDataStatusOn));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLMyKey* testStruct = [[SDLMyKey alloc] init];
        
        expect(testStruct.e911Override).to(beNil());
    });
});

QuickSpecEnd
