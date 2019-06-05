//
//  SDLOnInteriorVehicleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnInteriorVehicleData* testNotification = [[SDLOnInteriorVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.moduleData).to(equal(someModuleData));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnInteriorVehicleData* testNotification = [[SDLOnInteriorVehicleData alloc] init];
        
        expect(testNotification.moduleData).to(beNil());
    });
});

QuickSpecEnd
