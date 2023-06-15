//
//  SDLSetInteriorVehicleDataResponseSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLSetInteriorVehicleDataResponse.h"
#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSetInteriorVehicleDataResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLModuleData* someModuleData = nil;
    
    beforeEach(^{
        someModuleData = [[SDLModuleData alloc] init];
    });
    
    it(@"Should set and get correctly", ^ {
        SDLSetInteriorVehicleDataResponse* testResponse = [[SDLSetInteriorVehicleDataResponse alloc] init];
        testResponse.moduleData = someModuleData;
        
        expect(testResponse.moduleData).to(equal(someModuleData));
    });
    
    
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleData:someModuleData},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetInteriorVehicleData}} mutableCopy];
        SDLSetInteriorVehicleDataResponse* testResponse = [[SDLSetInteriorVehicleDataResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetInteriorVehicleDataResponse* testResponse = [[SDLSetInteriorVehicleDataResponse alloc] init];
        
        expect(testResponse.moduleData).to(beNil());
    });
});

QuickSpecEnd
