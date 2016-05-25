//
//  SDLGPSDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCompassDirection.h"
#import "SDLDimension.h"
#import "SDLGPSData.h"
#import "SDLNames.h"


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
        testStruct.compassDirection = [SDLCompassDirection SOUTHEAST];
        testStruct.pdop = @3.4;
        testStruct.hdop = @9.9;
        testStruct.vdop = @0;
        testStruct.actual = @NO;
        testStruct.satellites = @12;
        testStruct.dimension = [SDLDimension _3D];
        testStruct.altitude = @3000;
        testStruct.heading = @96;
        testStruct.speed = @64;
        
        expect(testStruct.longitudeDegrees).to(equal(@31.41592653589793));
        expect(testStruct.latitudeDegrees).to(equal(@45));
        expect(testStruct.utcYear).to(equal(@2015));
        expect(testStruct.utcMonth).to(equal(@1));
        expect(testStruct.utcDay).to(equal(@26));
        expect(testStruct.utcHours).to(equal(@23));
        expect(testStruct.utcMinutes).to(equal(@59));
        expect(testStruct.utcSeconds).to(equal(@59));
        expect(testStruct.compassDirection).to(equal([SDLCompassDirection SOUTHEAST]));
        expect(testStruct.pdop).to(equal(@3.4));
        expect(testStruct.hdop).to(equal(@9.9));
        expect(testStruct.vdop).to(equal(@0));
        expect(testStruct.actual).to(equal(@NO));
        expect(testStruct.satellites).to(equal(@12));
        expect(testStruct.dimension).to(equal([SDLDimension _3D]));
        expect(testStruct.altitude).to(equal(@3000));
        expect(testStruct.heading).to(equal(@96));
        expect(testStruct.speed).to(equal(@64));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_longitudeDegrees:@31.41592653589793,
                                       NAMES_latitudeDegrees:@45,
                                       NAMES_utcYear:@2015,
                                       NAMES_utcMonth:@1,
                                       NAMES_utcDay:@26,
                                       NAMES_utcHours:@23,
                                       NAMES_utcMinutes:@59,
                                       NAMES_utcSeconds:@59,
                                       NAMES_compassDirection:[SDLCompassDirection SOUTHEAST],
                                       NAMES_pdop:@3.4,
                                       NAMES_hdop:@9.9,
                                       NAMES_vdop:@0,
                                       NAMES_actual:@NO,
                                       NAMES_satellites:@12,
                                       NAMES_dimension:[SDLDimension _3D],
                                       NAMES_altitude:@3000,
                                       NAMES_heading:@96,
                                       NAMES_speed:@64} mutableCopy];
        SDLGPSData* testStruct = [[SDLGPSData alloc] initWithDictionary:dict];
        
        expect(testStruct.longitudeDegrees).to(equal(@31.41592653589793));
        expect(testStruct.latitudeDegrees).to(equal(@45));
        expect(testStruct.utcYear).to(equal(@2015));
        expect(testStruct.utcMonth).to(equal(@1));
        expect(testStruct.utcDay).to(equal(@26));
        expect(testStruct.utcHours).to(equal(@23));
        expect(testStruct.utcMinutes).to(equal(@59));
        expect(testStruct.utcSeconds).to(equal(@59));
        expect(testStruct.compassDirection).to(equal([SDLCompassDirection SOUTHEAST]));
        expect(testStruct.pdop).to(equal(@3.4));
        expect(testStruct.hdop).to(equal(@9.9));
        expect(testStruct.vdop).to(equal(@0));
        expect(testStruct.actual).to(equal(@NO));
        expect(testStruct.satellites).to(equal(@12));
        expect(testStruct.dimension).to(equal([SDLDimension _3D]));
        expect(testStruct.altitude).to(equal(@3000));
        expect(testStruct.heading).to(equal(@96));
        expect(testStruct.speed).to(equal(@64));
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
    });
});

QuickSpecEnd