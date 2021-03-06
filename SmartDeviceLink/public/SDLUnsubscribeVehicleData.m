//  SDLUnsubscribeVehicleData.m
//


#import "SDLUnsubscribeVehicleData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeVehicleData

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameUnsubscribeVehicleData];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation  cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus {
    self = [self initWithGps:@(gps) speed:@(speed) rpm:@(rpm) instantFuelConsumption:@(instantFuelConsumption) fuelRange:@(fuelRange) climateData:nil turnSignal:@(turnSignal) gearStatus:nil tirePressure:@(tirePressure) odometer:@(odometer) beltStatus:@(beltStatus) bodyInformation:@(bodyInformation) deviceStatus:@(deviceStatus) driverBraking:@(driverBraking) wiperStatus:@(wiperStatus) headLampStatus:@(headLampStatus) engineTorque:@(engineTorque) accPedalPosition:@(accPedalPosition) steeringWheelAngle:@(steeringWheelAngle) engineOilLife:@(engineOilLife) electronicParkBrakeStatus:@(electronicParkBrakeStatus) cloudAppVehicleID:@(cloudAppVehicleID) stabilityControlsStatus:nil eCallInfo:@(eCallInfo) airbagStatus:@(airbagStatus) emergencyEvent:@(emergencyEvent) clusterModeStatus:@(clusterModeStatus) myKey:@(myKey) windowStatus:nil handsOffSteering:nil seatOccupancy:nil];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.fuelLevel = @(fuelLevel);
        self.fuelLevel_State = @(fuelLevelState);
        self.prndl = @(prndl);
        self.externalTemperature = @(externalTemperature);
#pragma clang diagnostic pop
    }
    return self;
}

- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal gearStatus:(nullable NSNumber<SDLBool> *)gearStatus tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID stabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering windowStatus:(nullable NSNumber<SDLBool> *)windowStatus {
    self = [self initWithGps:gps speed:speed rpm:rpm instantFuelConsumption:instantFuelConsumption fuelRange:fuelRange climateData:nil turnSignal:turnSignal gearStatus:gearStatus tirePressure:tirePressure odometer:odometer beltStatus:beltStatus bodyInformation:bodyInformation deviceStatus:deviceStatus driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLampStatus engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID stabilityControlsStatus:stabilityControlsStatus eCallInfo:eCallInfo airbagStatus:airbagStatus emergencyEvent:emergencyEvent clusterModeStatus:clusterModeStatus myKey:myKey windowStatus:windowStatus handsOffSteering:handsOffSteering seatOccupancy:nil];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.externalTemperature = externalTemperature;
#pragma clang diagnostic pop
    }
    return self;
}

- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange climateData:(nullable NSNumber<SDLBool> *)climateData turnSignal:(nullable NSNumber<SDLBool> *)turnSignal gearStatus:(nullable NSNumber<SDLBool> *)gearStatus tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID stabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey windowStatus:(nullable NSNumber<SDLBool> *)windowStatus handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering seatOccupancy:(nullable NSNumber<SDLBool> *)seatOccupancy {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.gps = gps;
    self.speed = speed;
    self.rpm = rpm;
    self.instantFuelConsumption = instantFuelConsumption;
    self.fuelRange = fuelRange;
    self.climateData = climateData;
    self.turnSignal = turnSignal;
    self.gearStatus = gearStatus;
    self.tirePressure = tirePressure;
    self.odometer = odometer;
    self.beltStatus = beltStatus;
    self.bodyInformation = bodyInformation;
    self.deviceStatus = deviceStatus;
    self.driverBraking = driverBraking;
    self.wiperStatus = wiperStatus;
    self.headLampStatus = headLampStatus;
    self.engineTorque = engineTorque;
    self.accPedalPosition = accPedalPosition;
    self.steeringWheelAngle = steeringWheelAngle;
    self.engineOilLife = engineOilLife;
    self.electronicParkBrakeStatus = electronicParkBrakeStatus;
    self.cloudAppVehicleID = cloudAppVehicleID;
    self.stabilityControlsStatus = stabilityControlsStatus;
    self.eCallInfo = eCallInfo;
    self.airbagStatus = airbagStatus;
    self.emergencyEvent = emergencyEvent;
    self.clusterModeStatus = clusterModeStatus;
    self.myKey = myKey;
    self.windowStatus = windowStatus;
    self.handsOffSteering = handsOffSteering;
    self.seatOccupancy = seatOccupancy;
    return self;
}

- (void)setGearStatus:(nullable NSNumber<SDLBool> *)gearStatus {
    [self.parameters sdl_setObject:gearStatus forName:SDLRPCParameterNameGearStatus];
}

- (nullable NSNumber<SDLBool> *)gearStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGearStatus ofClass:NSNumber.class error:nil];
}

- (void)setGps:(nullable NSNumber<SDLBool> *)gps {
    [self.parameters sdl_setObject:gps forName:SDLRPCParameterNameGPS];
}

- (nullable NSNumber<SDLBool> *)gps {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGPS ofClass:NSNumber.class error:nil];
}

- (void)setSpeed:(nullable NSNumber<SDLBool> *)speed {
    [self.parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLBool> *)speed {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpeed ofClass:NSNumber.class error:nil];
}

- (void)setRpm:(nullable NSNumber<SDLBool> *)rpm {
    [self.parameters sdl_setObject:rpm forName:SDLRPCParameterNameRPM];
}

- (nullable NSNumber<SDLBool> *)rpm {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRPM ofClass:NSNumber.class error:nil];
}

- (void)setFuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel {
    [self.parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable NSNumber<SDLBool> *)fuelLevel {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevel ofClass:NSNumber.class error:nil];
}

- (void)setFuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State {
    [self.parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevelState];
}

- (nullable NSNumber<SDLBool> *)fuelLevel_State {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevelState ofClass:NSNumber.class error:nil];
}

- (void)setFuelRange:(nullable NSNumber<SDLBool> *)fuelRange {
    [self.parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable NSNumber<SDLBool> *)fuelRange {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelRange ofClass:NSNumber.class error:nil];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption {
    [self.parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (nullable NSNumber<SDLBool> *)instantFuelConsumption {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption ofClass:NSNumber.class error:nil];
}

- (void)setClimateData:(nullable NSNumber<SDLBool> *)climateData {
    [self.parameters sdl_setObject:climateData forName:SDLRPCParameterNameClimateData];
}

- (nullable NSNumber<SDLBool> *)climateData {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClimateData ofClass:NSNumber.class error:nil];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature {
    [self.parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable NSNumber<SDLBool> *)externalTemperature {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:NSNumber.class error:nil];
}

- (void)setPrndl:(nullable NSNumber<SDLBool> *)prndl {
    [self.parameters sdl_setObject:prndl forName:SDLRPCParameterNamePRNDL];
}

- (nullable NSNumber<SDLBool> *)prndl {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePRNDL ofClass:NSNumber.class error:nil];
}

- (void)setTirePressure:(nullable NSNumber<SDLBool> *)tirePressure {
    [self.parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable NSNumber<SDLBool> *)tirePressure {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:NSNumber.class error:nil];
}

- (void)setOdometer:(nullable NSNumber<SDLBool> *)odometer {
    [self.parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable NSNumber<SDLBool> *)odometer {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOdometer ofClass:NSNumber.class error:nil];
}

- (void)setBeltStatus:(nullable NSNumber<SDLBool> *)beltStatus {
    [self.parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable NSNumber<SDLBool> *)beltStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:NSNumber.class error:nil];
}

- (void)setBodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation {
    [self.parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable NSNumber<SDLBool> *)bodyInformation {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:NSNumber.class error:nil];
}

- (void)setDeviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus {
    [self.parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable NSNumber<SDLBool> *)deviceStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:NSNumber.class error:nil];
}

- (void)setDriverBraking:(nullable NSNumber<SDLBool> *)driverBraking {
    [self.parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable NSNumber<SDLBool> *)driverBraking {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDriverBraking ofClass:NSNumber.class error:nil];
}

- (void)setWiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus {
    [self.parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable NSNumber<SDLBool> *)wiperStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWiperStatus ofClass:NSNumber.class error:nil];
}

- (void)setHandsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering {
    [self.parameters sdl_setObject:handsOffSteering forName:SDLRPCParameterNameHandsOffSteering];
}

- (nullable NSNumber<SDLBool> *)handsOffSteering {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHandsOffSteering ofClass:NSNumber.class error:&error];
}

- (void)setHeadLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus {
    [self.parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable NSNumber<SDLBool> *)headLampStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:NSNumber.class error:nil];
}

- (void)setEngineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife {
    [self.parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable NSNumber<SDLBool> *)engineOilLife {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife ofClass:NSNumber.class error:nil];
}

- (void)setEngineTorque:(nullable NSNumber<SDLBool> *)engineTorque {
    [self.parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable NSNumber<SDLBool> *)engineTorque {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineTorque ofClass:NSNumber.class error:nil];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition {
    [self.parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (nullable NSNumber<SDLBool> *)accPedalPosition {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAccelerationPedalPosition ofClass:NSNumber.class error:nil];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle {
    [self.parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLBool> *)steeringWheelAngle {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle ofClass:NSNumber.class error:nil];
}

- (void)setECallInfo:(nullable NSNumber<SDLBool> *)eCallInfo {
    [self.parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable NSNumber<SDLBool> *)eCallInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:NSNumber.class error:nil];
}

- (void)setAirbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus {
    [self.parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable NSNumber<SDLBool> *)airbagStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:NSNumber.class error:nil];
}

- (void)setEmergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent {
    [self.parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable NSNumber<SDLBool> *)emergencyEvent {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:NSNumber.class error:nil];
}

- (void)setClusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus {
    [self.parameters sdl_setObject:clusterModeStatus forName:SDLRPCParameterNameClusterModeStatus];
}

- (nullable NSNumber<SDLBool> *)clusterModeStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClusterModeStatus ofClass:NSNumber.class error:nil];
}

- (void)setMyKey:(nullable NSNumber<SDLBool> *)myKey {
    [self.parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable NSNumber<SDLBool> *)myKey {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:NSNumber.class error:nil];
}

- (void)setElectronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus {
    [self.parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable NSNumber<SDLBool> *)electronicParkBrakeStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameElectronicParkBrakeStatus ofClass:NSNumber.class error:nil];
}

- (void)setTurnSignal:(nullable NSNumber<SDLBool> *)turnSignal {
    [self.parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable NSNumber<SDLBool> *)turnSignal {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTurnSignal ofClass:NSNumber.class error:nil];
}

- (void)setCloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID {
    [self.parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable NSNumber<SDLBool> *)cloudAppVehicleID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID ofClass:NSNumber.class error:nil];
}

- (void)setStabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus {
    [self.parameters sdl_setObject:stabilityControlsStatus forName:SDLRPCParameterNameStabilityControlsStatus];
}

- (nullable NSNumber<SDLBool> *)stabilityControlsStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameStabilityControlsStatus ofClass:NSNumber.class error:nil];
}

- (void)setWindowStatus:(nullable NSNumber<SDLBool> *)windowStatus {
    [self.parameters sdl_setObject:windowStatus forName:SDLRPCParameterNameWindowStatus];
}

- (nullable NSNumber<SDLBool> *)windowStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowStatus ofClass:NSNumber.class error:&error];
}

- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState {
    [self.parameters sdl_setObject:@(vehicleDataState) forName:vehicleDataName];
}

- (nullable NSNumber<SDLBool> *)getOEMCustomVehicleData:(NSString *)vehicleDataName {
    return [self.parameters sdl_objectForName:vehicleDataName ofClass:NSNumber.class error:nil];
}

- (void)setSeatOccupancy:(nullable NSNumber<SDLBool> *)seatOccupancy {
    [self.parameters sdl_setObject:seatOccupancy forName:SDLRPCParameterNameSeatOccupancy];
}

- (nullable NSNumber<SDLBool> *)seatOccupancy {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSeatOccupancy ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
