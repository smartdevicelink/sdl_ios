//
//  SDLTemperatureSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTemperature.h"
#import "SDLTemperatureUnit.h"
#import "SDLNames.h"

QuickSpecBegin(SDLTemperatureSpec)

describe(@"Initialization tests", ^{
    
    it(@"should properly initialize init", ^{
        SDLTemperature* testStruct = [[SDLTemperature alloc] init];
        
        expect(testStruct.unit).to(beNil());
        expect(testStruct.value).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameUnit : SDLTemperatureUnitCelsius ,
                                           SDLNameValue:@30 } mutableCopy];
        SDLTemperature* testStruct = [[SDLTemperature alloc] initWithDictionary:dict];
        
        expect(testStruct.unit).to(equal(SDLTemperatureUnitCelsius));
        expect(testStruct.value).to(equal(@30));
    });
    
    it(@"Should set and get correctly", ^{
        SDLTemperature* testStruct = [[SDLTemperature alloc] init];
        
        testStruct.unit = SDLTemperatureUnitCelsius;
        testStruct.value = @30;
        
        expect(testStruct.unit).to(equal(SDLTemperatureUnitCelsius));
        expect(testStruct.value).to(equal(@30));
    });
});

QuickSpecEnd
