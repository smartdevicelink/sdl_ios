//  SDLElectronicParkBrakeStatus.h
//


#import "SDLEnum.h"

/**
 Reflects the status of the Electronic Parking Brake. A Vehicle Data Type.
 */
typedef SDLEnum SDLElectronicParkBrakeStatus NS_TYPED_ENUM;

/**
 Parking brake actuators have been fully applied.
 */
extern SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusClosed;

/**
 Parking brake actuators are transitioning to either Apply/Closed or Release/Open state.
 */
extern SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusTransition;

/**
 Parking brake actuators are released.
 */
extern SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusOpen;

/**
 When driver pulls the Electronic Parking Brake switch while driving "at speed".
 */
extern SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusDriveActive;

/**
 When system has a fault or is under maintenance.
 */
extern SDLElectronicParkBrakeStatus const SDLElectronicParkBrakeStatusFault;
