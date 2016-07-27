//
//  SDLHeadLampStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAmbientLightStatus.h"
#import "SDLHeadLampStatus.h"
#import "SDLNames.h"


QuickSpecBegin(SDLHeadLampStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] init];
        
        testStruct.lowBeamsOn = @YES;
        testStruct.highBeamsOn = @NO;
        testStruct.ambientLightSensorStatus = [SDLAmbientLightStatus TWILIGHT_3];
        
        expect(testStruct.lowBeamsOn).to(equal(@YES));
        expect(testStruct.highBeamsOn).to(equal(@NO));
        expect(testStruct.ambientLightSensorStatus).to(equal([SDLAmbientLightStatus TWILIGHT_3]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_lowBeamsOn:@YES,
                                       NAMES_highBeamsOn:@NO,
                                       NAMES_ambientLightSensorStatus:[SDLAmbientLightStatus TWILIGHT_3]} mutableCopy];
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.lowBeamsOn).to(equal(@YES));
        expect(testStruct.highBeamsOn).to(equal(@NO));
        expect(testStruct.ambientLightSensorStatus).to(equal([SDLAmbientLightStatus TWILIGHT_3]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] init];
        
        expect(testStruct.lowBeamsOn).to(beNil());
        expect(testStruct.highBeamsOn).to(beNil());
        expect(testStruct.ambientLightSensorStatus).to(beNil());
    });
});

QuickSpecEnd