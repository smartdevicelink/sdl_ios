//
//  SDLSetInteriorVehicleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetInteriorVehicleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleData : someModuleData},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetInteriorVehicleData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSetInteriorVehicleData* testRequest = [[SDLSetInteriorVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
