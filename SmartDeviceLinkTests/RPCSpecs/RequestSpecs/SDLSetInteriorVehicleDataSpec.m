//
//  SDLSetInteriorVehicleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetInteriorVehicleData.h"
#import "SDLNames.h"
#import "SDLModuleData.h"


QuickSpecBegin(SDLSetInteriorVehicleDataSpec)

SDLModuleData *someModuleData = [[SDLModuleData alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetInteriorVehicleData* testRequest = [[SDLSetInteriorVehicleData alloc] init];
        testRequest.moduleData = someModuleData;
        
        expect(testRequest.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameModuleData : someModuleData},
                                                             SDLNameOperationName:SDLNameSetInteriorVehicleData}} mutableCopy];
        SDLSetInteriorVehicleData* testRequest = [[SDLSetInteriorVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.moduleData).to(equal(someModuleData));
    });

    it(@"Should get correctly when initialized with module data", ^ {
        SDLSetInteriorVehicleData* testRequest = [[SDLSetInteriorVehicleData alloc] initWithModuleData:someModuleData];

        expect(testRequest.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetInteriorVehicleData* testRequest = [[SDLSetInteriorVehicleData alloc] init];
        
        expect(testRequest.moduleData).to(beNil());
    });
});

QuickSpecEnd
