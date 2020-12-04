//  SDLTPMS.h
//


#import "SDLEnum.h"

/**
 An enum representing values of the tire pressure monitoring system
 */
typedef SDLEnum SDLTPMS NS_TYPED_ENUM;

/**
 If set the status of the tire is not known.
 */
extern SDLTPMS const SDLTPMSUnknown;

/**
 TPMS does not function.
 */
extern SDLTPMS const SDLTPMSSystemFault;

/**
 The sensor of the tire does not function.
 */
extern SDLTPMS const SDLTPMSSensorFault;

/**
 TPMS is reporting a low tire pressure for the tire.
 */
extern SDLTPMS const SDLTPMSLow;

/**
 TPMS is active and the tire pressure is monitored.
 */
extern SDLTPMS const SDLTPMSSystemActive;

/**
 TPMS is reporting that the tire must be trained.
 */
extern SDLTPMS const SDLTPMSTrain;

/**
 TPMS reports the training for the tire is completed.
 */
extern SDLTPMS const SDLTPMSTrainingComplete;

/**
 TPMS reports the tire is not trained.
 */
extern SDLTPMS const SDLTPMSNotTrained;
