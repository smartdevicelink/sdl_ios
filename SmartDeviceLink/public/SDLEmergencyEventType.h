//  SDLEmergencyEventType.h
//


#import "SDLEnum.h"

/**
 Reflects the emergency event status of the vehicle. Used in EmergencyEvent

 Since SmartDeviceLink 2.0
 */
typedef SDLEnum SDLEmergencyEventType NS_TYPED_ENUM;

/**
 No emergency event has happened.
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeNoEvent;

/**
 Frontal collision has happened.
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeFrontal;

/**
 Side collision has happened.
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeSide;

/**
 Rear collision has happened.
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeRear;

/**
 A rollover event has happened.
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeRollover;

/**
 The signal is not supported
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeNotSupported;

/**
 Emergency status cannot be determined
 */
extern SDLEmergencyEventType const SDLEmergencyEventTypeFault;
