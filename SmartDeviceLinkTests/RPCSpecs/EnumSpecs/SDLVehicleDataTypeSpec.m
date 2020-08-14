//
//  SDLVehicleDataTypeSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLVehicleDataType.h"

QuickSpecBegin(SDLVehicleDataTypeSpec)

describe(@"individual enum value tests", ^{
    it(@"should match internal values", ^{
        expect(SDLVehicleDataTypeAccelerationPedal).to(equal(@"VEHICLEDATA_ACCPEDAL"));
        expect(SDLVehicleDataTypeAirbagStatus).to(equal(@"VEHICLEDATA_AIRBAGSTATUS"));
        expect(SDLVehicleDataTypeBatteryVoltage).to(equal(@"VEHICLEDATA_BATTVOLTAGE"));
        expect(SDLVehicleDataTypeBeltStatus).to(equal(@"VEHICLEDATA_BELTSTATUS"));
        expect(SDLVehicleDataTypeBodyInfo).to(equal(@"VEHICLEDATA_BODYINFO"));
        expect(SDLVehicleDataTypeBraking).to(equal(@"VEHICLEDATA_BRAKING"));
        expect(SDLVehicleDataTypeCloudAppVehicleID).to(equal(@"VEHICLEDATA_CLOUDAPPVEHICLEID"));
        expect(SDLVehicleDataTypeClusterModeStatus).to(equal(@"VEHICLEDATA_CLUSTERMODESTATUS"));
        expect(SDLVehicleDataTypeDeviceStatus).to(equal(@"VEHICLEDATA_DEVICESTATUS"));
        expect(SDLVehicleDataTypeECallInfo).to(equal(@"VEHICLEDATA_ECALLINFO"));
        expect(SDLVehicleDataTypeElectronicParkBrakeStatus).to(equal(@"VEHICLEDATA_ELECTRONICPARKBRAKESTATUS"));
        expect(SDLVehicleDataTypeEmergencyEvent).to(equal(@"VEHICLEDATA_EMERGENCYEVENT"));
        expect(SDLVehicleDataTypeEngineOilLife).to(equal(@"VEHICLEDATA_ENGINEOILLIFE"));
        expect(SDLVehicleDataTypeEngineTorque).to(equal(@"VEHICLEDATA_ENGINETORQUE"));
        expect(SDLVehicleDataTypeExternalTemperature).to(equal(@"VEHICLEDATA_EXTERNTEMP"));
        expect(SDLVehicleDataTypeFuelConsumption).to(equal(@"VEHICLEDATA_FUELCONSUMPTION"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLVehicleDataTypeFuelLevel).to(equal(@"VEHICLEDATA_FUELLEVEL"));
        expect(SDLVehicleDataTypeFuelLevelState).to(equal(@"VEHICLEDATA_FUELLEVEL_STATE"));
#pragma clang diagnostic pop
        expect(SDLVehicleDataTypeFuelRange).to(equal(@"VEHICLEDATA_FUELRANGE"));
        expect(SDLVehicleDataTypeGPS).to(equal(@"VEHICLEDATA_GPS"));
        expect(SDLVehicleDataTypeGearStatus).to(equal(@"VEHICLEDATA_GEARSTATUS"));
        expect(SDLVehicleDataTypeHandsOffSteering).to(equal(@"VEHICLEDATA_HANDSOFFSTEERING"));
        expect(SDLVehicleDataTypeHeadlampStatus).to(equal(@"VEHICLEDATA_HEADLAMPSTATUS"));
        expect(SDLVehicleDataTypeMyKey).to(equal(@"VEHICLEDATA_MYKEY"));
        expect(SDLVehicleDataTypeOdometer).to(equal(@"VEHICLEDATA_ODOMETER"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLVehicleDataTypePrndl).to(equal(@"VEHICLEDATA_PRNDL"));
#pragma clang diagnostic pop
        expect(SDLVehicleDataTypeRPM).to(equal(@"VEHICLEDATA_RPM"));
        expect(SDLVehicleDataTypeSpeed).to(equal(@"VEHICLEDATA_SPEED"));
        expect(SDLVehicleDataTypeSteeringWheel).to(equal(@"VEHICLEDATA_STEERINGWHEEL"));
        expect(SDLVehicleDataTypeTirePressure).to(equal(@"VEHICLEDATA_TIREPRESSURE"));
        expect(SDLVehicleDataTypeTurnSignal).to(equal(@"VEHICLEDATA_TURNSIGNAL"));
        expect(SDLVehicleDataTypeVIN).to(equal(@"VEHICLEDATA_VIN"));
        expect(SDLVehicleDataTypeWiperStatus).to(equal(@"VEHICLEDATA_WIPERSTATUS"));
    });
});

QuickSpecEnd
