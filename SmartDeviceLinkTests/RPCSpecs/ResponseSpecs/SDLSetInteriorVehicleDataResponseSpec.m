//
//  SDLSetInteriorVehicleDataResponseSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetInteriorVehicleDataResponse.h"
#import "SDLModuleData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSetInteriorVehicleDataResponseSpec)

SDLModuleData *someModuleData = [[SDLModuleData alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetInteriorVehicleDataResponse* testResponse = [[SDLSetInteriorVehicleDataResponse alloc] init];
        testResponse.moduleData = someModuleData;
        
        expect(testResponse.moduleData).to(equal(someModuleData));
    });
    
    
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameResponse:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameModuleData:someModuleData},
                                                             SDLNameOperationName:SDLNameSetInteriorVehicleData}} mutableCopy];
        SDLSetInteriorVehicleDataResponse* testResponse = [[SDLSetInteriorVehicleDataResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetInteriorVehicleDataResponse* testResponse = [[SDLSetInteriorVehicleDataResponse alloc] init];
        
        expect(testResponse.moduleData).to(beNil());
    });
});

QuickSpecEnd
