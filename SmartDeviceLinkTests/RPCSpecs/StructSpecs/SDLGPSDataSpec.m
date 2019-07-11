//
//  SDLGPSDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCompassDirection.h"
#import "SDLDimension.h"
#import "SDLGPSData.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLGPSDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGPSData* testStruct = [[SDLGPSData alloc] init];
        
        testStruct.longitudeDegrees = @31.41592653589793;
        testStruct.latitudeDegrees = @45;
        testStruct.utcYear = @2015;
        testStruct.utcMonth = @1;
        testStruct.utcDay = @26;
        testStruct.utcHours = @23;
        testStruct.utcMinutes = @59;
        testStruct.utcSeconds = @59;
        testStruct.compassDirection = SDLCompassDirectionSoutheast;
        testStruct.pdop = @3.4;
        testStruct.hdop = @9.9;
        testStruct.vdop = @0;
        testStruct.actual = @NO;
        testStruct.satellites = @12;
        testStruct.dimension = SDLDimension3D;
        testStruct.altitude = @3000;
        testStruct.heading = @96;
        testStruct.speed = @64;
        testStruct.shifted = @(NO);
        
        expect(testStruct.longitudeDegrees).to(equal(@31.41592653589793));
        expect(testStruct.latitudeDegrees).to(equal(@45));
        expect(testStruct.utcYear).to(equal(@2015));
        expect(testStruct.utcMonth).to(equal(@1));
        expect(testStruct.utcDay).to(equal(@26));
        expect(testStruct.utcHours).to(equal(@23));
        expect(testStruct.utcMinutes).to(equal(@59));
        expect(testStruct.utcSeconds).to(equal(@59));
        expect(testStruct.compassDirection).to(equal(SDLCompassDirectionSoutheast));
        expect(testStruct.pdop).to(equal(@3.4));
        expect(testStruct.hdop).to(equal(@9.9));
        expect(testStruct.vdop).to(equal(@0));
        expect(testStruct.actual).to(equal(@NO));
        expect(testStruct.satellites).to(equal(@12));
        expect(testStruct.dimension).to(equal(SDLDimension3D));
        expect(testStruct.altitude).to(equal(@3000));
        expect(testStruct.heading).to(equal(@96));
        expect(testStruct.speed).to(equal(@64));
        expect(testStruct.shifted).to(equal(@(NO)));

    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameLongitudeDegrees:@31.41592653589793,
                                       SDLRPCParameterNameLatitudeDegrees:@45,
                                       SDLRPCParameterNameUTCYear:@2015,
                                       SDLRPCParameterNameUTCMonth:@1,
                                       SDLRPCParameterNameUTCDay:@26,
                                       SDLRPCParameterNameUTCHours:@23,
                                       SDLRPCParameterNameUTCMinutes:@59,
                                       SDLRPCParameterNameUTCSeconds:@59,
                                       SDLRPCParameterNameCompassDirection:SDLCompassDirectionSoutheast,
                                       SDLRPCParameterNamePDOP:@3.4,
                                       SDLRPCParameterNameHDOP:@9.9,
                                       SDLRPCParameterNameVDOP:@0,
                                       SDLRPCParameterNameActual:@NO,
                                       SDLRPCParameterNameSatellites:@12,
                                       SDLRPCParameterNameDimension:SDLDimension3D,
                                       SDLRPCParameterNameAltitude:@3000,
                                       SDLRPCParameterNameHeading:@96,
                                       SDLRPCParameterNameSpeed:@64,
                                       SDLRPCParameterNameShifted:@(NO)
                                       } mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGPSData* testStruct = [[SDLGPSData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.longitudeDegrees).to(equal(@31.41592653589793));
        expect(testStruct.latitudeDegrees).to(equal(@45));
        expect(testStruct.utcYear).to(equal(@2015));
        expect(testStruct.utcMonth).to(equal(@1));
        expect(testStruct.utcDay).to(equal(@26));
        expect(testStruct.utcHours).to(equal(@23));
        expect(testStruct.utcMinutes).to(equal(@59));
        expect(testStruct.utcSeconds).to(equal(@59));
        expect(testStruct.compassDirection).to(equal(SDLCompassDirectionSoutheast));
        expect(testStruct.pdop).to(equal(@3.4));
        expect(testStruct.hdop).to(equal(@9.9));
        expect(testStruct.vdop).to(equal(@0));
        expect(testStruct.actual).to(equal(@NO));
        expect(testStruct.satellites).to(equal(@12));
        expect(testStruct.dimension).to(equal(SDLDimension3D));
        expect(testStruct.altitude).to(equal(@3000));
        expect(testStruct.heading).to(equal(@96));
        expect(testStruct.speed).to(equal(@64));
        expect(testStruct.shifted).to(equal(@(NO)));

    });
    
    it(@"Should return nil if not set", ^ {
        SDLGPSData* testStruct = [[SDLGPSData alloc] init];
        
        expect(testStruct.longitudeDegrees).to(beNil());
        expect(testStruct.latitudeDegrees).to(beNil());
        expect(testStruct.utcYear).to(beNil());
        expect(testStruct.utcMonth).to(beNil());
        expect(testStruct.utcDay).to(beNil());
        expect(testStruct.utcHours).to(beNil());
        expect(testStruct.utcMinutes).to(beNil());
        expect(testStruct.utcSeconds).to(beNil());
        expect(testStruct.compassDirection).to(beNil());
        expect(testStruct.pdop).to(beNil());
        expect(testStruct.hdop).to(beNil());
        expect(testStruct.vdop).to(beNil());
        expect(testStruct.actual).to(beNil());
        expect(testStruct.satellites).to(beNil());
        expect(testStruct.dimension).to(beNil());
        expect(testStruct.altitude).to(beNil());
        expect(testStruct.heading).to(beNil());
        expect(testStruct.speed).to(beNil());
        expect(testStruct.shifted).to(beNil());

    });
});

QuickSpecEnd
