//
//  SDLOnInteriorVehicleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLOnInteriorVehicleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLModuleData.h"

QuickSpecBegin(SDLOnInteriorVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLModuleData* someModuleData = nil;
    
    beforeEach(^{
        someModuleData = [[SDLModuleData alloc] init];
    });
    
    it(@"Should set and get correctly", ^ {
        SDLOnInteriorVehicleData* testNotification = [[SDLOnInteriorVehicleData alloc] init];
        
        testNotification.moduleData = someModuleData;
        
        expect(testNotification.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameNotification:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleData:someModuleData},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnInteriorVehicleData}} mutableCopy];
        SDLOnInteriorVehicleData* testNotification = [[SDLOnInteriorVehicleData alloc] initWithDictionary:dict];
        
        expect(testNotification.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnInteriorVehicleData* testNotification = [[SDLOnInteriorVehicleData alloc] init];
        
        expect(testNotification.moduleData).to(beNil());
    });
});

QuickSpecEnd
