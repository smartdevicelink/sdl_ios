//
//  SDLElectronicParkBrakeStatus.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/16/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLElectronicParkBrakeStatus.h"

typedef SDLEnum SDLElectronicParkBrakeStatus NS_TYPED_ENUM;


SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusClosed = @"CLOSED";
SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusTransition = @"TRANSITION";
SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusOpen = @"OPEN";
SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusDriveActive = @"DRIVE_ACTIVE";
SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusFault = @"FAULT";
