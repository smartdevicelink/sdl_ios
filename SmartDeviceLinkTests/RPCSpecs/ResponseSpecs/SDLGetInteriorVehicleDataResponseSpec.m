//
//  SDLGetInteriorVehicleDataResponseSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetInteriorVehicleDataResponse.h"
#import "SDLModuleData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetInteriorVehicleDataResponseSpec)
SDLModuleData* someModuleData = [[SDLModuleData alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetInteriorVehicleDataResponse* testResponse = [[SDLGetInteriorVehicleDataResponse alloc] init];
        
        testResponse.moduleData = someModuleData;
        testResponse.isSubscribed = @NO;
        
        expect(testResponse.moduleData).to(equal(someModuleData));
        expect(testResponse.isSubscribed).to(equal(@NO));
    });
    
    
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameResponse:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameModuleData:someModuleData,
                                                                   SDLNameIsSubscribed:@NO},
                                                             SDLNameOperationName:SDLNameGetInteriorVehicleData}} mutableCopy];
        SDLGetInteriorVehicleDataResponse* testResponse = [[SDLGetInteriorVehicleDataResponse alloc] initWithDictionary:dict];
        
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
