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
        expect(SDLVehicleDataTypeGPS).to(equal(@"VEHICLEDATA_GPS"));
        expect(SDLVehicleDataTypeSpeed).to(equal(@"VEHICLEDATA_SPEED"));
        expect(SDLVehicleDataTypeRPM).to(equal(@"VEHICLEDATA_RPM"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLVehicleDataTypeFuelLevel).to(equal(@"VEHICLEDATA_FUELLEVEL"));
        expect(SDLVehicleDataTypeFuelLevelState).to(equal(@"VEHICLEDATA_FUELLEVEL_STATE"));
#pragma clang diagnostic pop
        expect(SDLVehicleDataTypeFuelConsumption).to(equal(@"VEHICLEDATA_FUELCONSUMPTION"));
        expect(SDLVehicleDataTypeFuelRange).to(equal(@"VEHICLEDATA_FUELRANGE"));
        expect(SDLVehicleDataTypeExternalTemperature).to(equal(@"VEHICLEDATA_EXTERNTEMP"));
        expect(SDLVehicleDataTypeVIN).to(equal(@"VEHICLEDATA_VIN"));
        expect(SDLVehicleDataTypePRNDL).to(equal(@"VEHICLEDATA_PRNDL"));
        expect(SDLVehicleDataTypeTirePressure).to(equal(@"VEHICLEDATA_TIREPRESSURE"));
        expect(SDLVehicleDataTypeOdometer).to(equal(@"VEHICLEDATA_ODOMETER"));
        expect(SDLVehicleDataTypeBeltStatus).to(equal(@"VEHICLEDATA_BELTSTATUS"));
        expect(SDLVehicleDataTypeBodyInfo).to(equal(@"VEHICLEDATA_BODYINFO"));
        expect(SDLVehicleDataTypeDeviceStatus).to(equal(@"VEHICLEDATA_DEVICESTATUS"));
        expect(SDLVehicleDataTypeECallInfo).to(equal(@"VEHICLEDATA_ECALLINFO"));
        expect(SDLVehicleDataTypeAirbagStatus).to(equal(@"VEHICLEDATA_AIRBAGSTATUS"));
        expect(SDLVehicleDataTypeEmergencyEvent).to(equal(@"VEHICLEDATA_EMERGENCYEVENT"));
        expect(SDLVehicleDataTypeClusterModeStatus).to(equal(@"VEHICLEDATA_CLUSTERMODESTATUS"));
        expect(SDLVehicleDataTypeMyKey).to(equal(@"VEHICLEDATA_MYKEY"));
        expect(SDLVehicleDataTypeBraking).to(equal(@"VEHICLEDATA_BRAKING"));
        expect(SDLVehicleDataTypeWiperStatus).to(equal(@"VEHICLEDATA_WIPERSTATUS"));
        expect(SDLVehicleDataTypeHeadlampStatus).to(equal(@"VEHICLEDATA_HEADLAMPSTATUS"));
        expect(SDLVehicleDataTypeBatteryVoltage).to(equal(@"VEHICLEDATA_BATTVOLTAGE"));
        expect(SDLVehicleDataTypeEngineOilLife).to(equal(@"VEHICLEDATA_ENGINEOILLIFE"));
        expect(SDLVehicleDataTypeEngineTorque).to(equal(@"VEHICLEDATA_ENGINETORQUE"));
        expect(SDLVehicleDataTypeAccelerationPedal).to(equal(@"VEHICLEDATA_ACCPEDAL"));
        expect(SDLVehicleDataTypeSteeringWheel).to(equal(@"VEHICLEDATA_STEERINGWHEEL"));
        expect(SDLVehicleDataTypeElectronicParkBrakeStatus).to(equal(@"VEHICLEDATA_ELECTRONICPARKBRAKESTATUS"));
        expect(SDLVehicleDataTypeTurnSignal).to(equal(@"VEHICLEDATA_TURNSIGNAL"));
        expect(SDLVehicleDataTypeCloudAppVehicleID).to(equal(@"VEHICLEDATA_CLOUDAPPVEHICLEID"));
        expect(SDLVehicleDataTypeHandsOffSteering).to(equal(@"VEHICLEDATA_HANDSOFFSTEERING"));
    });
});

QuickSpecEnd
