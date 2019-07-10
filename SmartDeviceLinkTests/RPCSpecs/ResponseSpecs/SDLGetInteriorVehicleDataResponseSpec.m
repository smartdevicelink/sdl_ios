//
//  SDLGetInteriorVehicleDataResponseSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetInteriorVehicleDataResponse.h"
#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetInteriorVehicleDataResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLModuleData* someModuleData = nil;
    
    beforeEach(^{
        someModuleData = [[SDLModuleData alloc] init];
    });
    
    it(@"Should set and get correctly", ^ {
        SDLGetInteriorVehicleDataResponse* testResponse = [[SDLGetInteriorVehicleDataResponse alloc] init];
        
        testResponse.moduleData = someModuleData;
        testResponse.isSubscribed = @NO;
        
        expect(testResponse.moduleData).to(equal(someModuleData));
        expect(testResponse.isSubscribed).to(equal(@NO));
    });
    
    
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleData:someModuleData,
                                                                   SDLRPCParameterNameIsSubscribed:@NO},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetInteriorVehicleData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetInteriorVehicleDataResponse* testResponse = [[SDLGetInteriorVehicleDataResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testResponse.moduleData).to(equal(someModuleData));
        expect(testResponse.isSubscribed).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetInteriorVehicleDataResponse* testResponse = [[SDLGetInteriorVehicleDataResponse alloc] init];
        
        expect(testResponse.moduleData).to(beNil());
        expect(testResponse.isSubscribed).to(beNil());
    });
});

QuickSpecEnd
