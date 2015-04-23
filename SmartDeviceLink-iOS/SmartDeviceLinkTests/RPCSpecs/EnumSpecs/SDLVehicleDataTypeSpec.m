//
//  SDLVehicleDataTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataType.h"

QuickSpecBegin(SDLVehicleDataTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVehicleDataType VEHICLEDATA_GPS].value).to(equal(@"VEHICLEDATA_GPS"));
        expect([SDLVehicleDataType VEHICLEDATA_SPEED].value).to(equal(@"VEHICLEDATA_SPEED"));
        expect([SDLVehicleDataType VEHICLEDATA_RPM].value).to(equal(@"VEHICLEDATA_RPM"));
        expect([SDLVehicleDataType VEHICLEDATA_FUELLEVEL].value).to(equal(@"VEHICLEDATA_FUELLEVEL"));
        expect([SDLVehicleDataType VEHICLEDATA_FUELLEVEL_STATE].value).to(equal(@"VEHICLEDATA_FUELLEVEL_STATE"));
        expect([SDLVehicleDataType VEHICLEDATA_FUELCONSUMPTION].value).to(equal(@"VEHICLEDATA_FUELCONSUMPTION"));
        expect([SDLVehicleDataType VEHICLEDATA_EXTERNTEMP].value).to(equal(@"VEHICLEDATA_EXTERNTEMP"));
        expect([SDLVehicleDataType VEHICLEDATA_VIN].value).to(equal(@"VEHICLEDATA_VIN"));
        expect([SDLVehicleDataType VEHICLEDATA_PRNDL].value).to(equal(@"VEHICLEDATA_PRNDL"));
        expect([SDLVehicleDataType VEHICLEDATA_TIREPRESSURE].value).to(equal(@"VEHICLEDATA_TIREPRESSURE"));
        expect([SDLVehicleDataType VEHICLEDATA_ODOMETER].value).to(equal(@"VEHICLEDATA_ODOMETER"));
        expect([SDLVehicleDataType VEHICLEDATA_BELTSTATUS].value).to(equal(@"VEHICLEDATA_BELTSTATUS"));
        expect([SDLVehicleDataType VEHICLEDATA_BODYINFO].value).to(equal(@"VEHICLEDATA_BODYINFO"));
        expect([SDLVehicleDataType VEHICLEDATA_DEVICESTATUS].value).to(equal(@"VEHICLEDATA_DEVICESTATUS"));
        expect([SDLVehicleDataType VEHICLEDATA_ECALLINFO].value).to(equal(@"VEHICLEDATA_ECALLINFO"));
        expect([SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS].value).to(equal(@"VEHICLEDATA_AIRBAGSTATUS"));
        expect([SDLVehicleDataType VEHICLEDATA_EMERGENCYEVENT].value).to(equal(@"VEHICLEDATA_EMERGENCYEVENT"));
        expect([SDLVehicleDataType VEHICLEDATA_CLUSTERMODESTATUS].value).to(equal(@"VEHICLEDATA_CLUSTERMODESTATUS"));
        expect([SDLVehicleDataType VEHICLEDATA_MYKEY].value).to(equal(@"VEHICLEDATA_MYKEY"));
        expect([SDLVehicleDataType VEHICLEDATA_BRAKING].value).to(equal(@"VEHICLEDATA_BRAKING"));
        expect([SDLVehicleDataType VEHICLEDATA_WIPERSTATUS].value).to(equal(@"VEHICLEDATA_WIPERSTATUS"));
        expect([SDLVehicleDataType VEHICLEDATA_HEADLAMPSTATUS].value).to(equal(@"VEHICLEDATA_HEADLAMPSTATUS"));
        expect([SDLVehicleDataType VEHICLEDATA_BATTVOLTAGE].value).to(equal(@"VEHICLEDATA_BATTVOLTAGE"));
        expect([SDLVehicleDataType VEHICLEDATA_ENGINETORQUE].value).to(equal(@"VEHICLEDATA_ENGINETORQUE"));
        expect([SDLVehicleDataType VEHICLEDATA_ACCPEDAL].value).to(equal(@"VEHICLEDATA_ACCPEDAL"));
        expect([SDLVehicleDataType VEHICLEDATA_STEERINGWHEEL].value).to(equal(@"VEHICLEDATA_STEERINGWHEEL"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_GPS"]).to(equal([SDLVehicleDataType VEHICLEDATA_GPS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_SPEED"]).to(equal([SDLVehicleDataType VEHICLEDATA_SPEED]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_RPM"]).to(equal([SDLVehicleDataType VEHICLEDATA_RPM]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_FUELLEVEL"]).to(equal([SDLVehicleDataType VEHICLEDATA_FUELLEVEL]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_FUELLEVEL_STATE"]).to(equal([SDLVehicleDataType VEHICLEDATA_FUELLEVEL_STATE]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_FUELCONSUMPTION"]).to(equal([SDLVehicleDataType VEHICLEDATA_FUELCONSUMPTION]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_EXTERNTEMP"]).to(equal([SDLVehicleDataType VEHICLEDATA_EXTERNTEMP]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_VIN"]).to(equal([SDLVehicleDataType VEHICLEDATA_VIN]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_PRNDL"]).to(equal([SDLVehicleDataType VEHICLEDATA_PRNDL]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_TIREPRESSURE"]).to(equal([SDLVehicleDataType VEHICLEDATA_TIREPRESSURE]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_ODOMETER"]).to(equal([SDLVehicleDataType VEHICLEDATA_ODOMETER]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_BELTSTATUS"]).to(equal([SDLVehicleDataType VEHICLEDATA_BELTSTATUS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_BODYINFO"]).to(equal([SDLVehicleDataType VEHICLEDATA_BODYINFO]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_DEVICESTATUS"]).to(equal([SDLVehicleDataType VEHICLEDATA_DEVICESTATUS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_ECALLINFO"]).to(equal([SDLVehicleDataType VEHICLEDATA_ECALLINFO]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_AIRBAGSTATUS"]).to(equal([SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_EMERGENCYEVENT"]).to(equal([SDLVehicleDataType VEHICLEDATA_EMERGENCYEVENT]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_CLUSTERMODESTATUS"]).to(equal([SDLVehicleDataType VEHICLEDATA_CLUSTERMODESTATUS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_MYKEY"]).to(equal([SDLVehicleDataType VEHICLEDATA_MYKEY]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_BRAKING"]).to(equal([SDLVehicleDataType VEHICLEDATA_BRAKING]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_WIPERSTATUS"]).to(equal([SDLVehicleDataType VEHICLEDATA_WIPERSTATUS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_HEADLAMPSTATUS"]).to(equal([SDLVehicleDataType VEHICLEDATA_HEADLAMPSTATUS]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_BATTVOLTAGE"]).to(equal([SDLVehicleDataType VEHICLEDATA_BATTVOLTAGE]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_ENGINETORQUE"]).to(equal([SDLVehicleDataType VEHICLEDATA_ENGINETORQUE]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_ACCPEDAL"]).to(equal([SDLVehicleDataType VEHICLEDATA_ACCPEDAL]));
        expect([SDLVehicleDataType valueOf:@"VEHICLEDATA_STEERINGWHEEL"]).to(equal([SDLVehicleDataType VEHICLEDATA_STEERINGWHEEL]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVehicleDataType valueOf:nil]).to(beNil());
        expect([SDLVehicleDataType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVehicleDataType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVehicleDataType VEHICLEDATA_GPS],
                        [SDLVehicleDataType VEHICLEDATA_SPEED],
                        [SDLVehicleDataType VEHICLEDATA_RPM],
                        [SDLVehicleDataType VEHICLEDATA_FUELLEVEL],
                        [SDLVehicleDataType VEHICLEDATA_FUELLEVEL_STATE],
                        [SDLVehicleDataType VEHICLEDATA_FUELCONSUMPTION],
                        [SDLVehicleDataType VEHICLEDATA_EXTERNTEMP],
                        [SDLVehicleDataType VEHICLEDATA_VIN],
                        [SDLVehicleDataType VEHICLEDATA_PRNDL],
                        [SDLVehicleDataType VEHICLEDATA_TIREPRESSURE],
                        [SDLVehicleDataType VEHICLEDATA_ODOMETER],
                        [SDLVehicleDataType VEHICLEDATA_BELTSTATUS],
                        [SDLVehicleDataType VEHICLEDATA_BODYINFO],
                        [SDLVehicleDataType VEHICLEDATA_DEVICESTATUS],
                        [SDLVehicleDataType VEHICLEDATA_ECALLINFO],
                        [SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS],
                        [SDLVehicleDataType VEHICLEDATA_EMERGENCYEVENT],
                        [SDLVehicleDataType VEHICLEDATA_CLUSTERMODESTATUS],
                        [SDLVehicleDataType VEHICLEDATA_MYKEY],
                        [SDLVehicleDataType VEHICLEDATA_BRAKING],
                        [SDLVehicleDataType VEHICLEDATA_WIPERSTATUS],
                        [SDLVehicleDataType VEHICLEDATA_HEADLAMPSTATUS],
                        [SDLVehicleDataType VEHICLEDATA_BATTVOLTAGE],
                        [SDLVehicleDataType VEHICLEDATA_ENGINETORQUE],
                        [SDLVehicleDataType VEHICLEDATA_ACCPEDAL],
                        [SDLVehicleDataType VEHICLEDATA_STEERINGWHEEL]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd