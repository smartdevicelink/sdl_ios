//  SDLECallConfirmationStatus.h
//


#import "SDLEnum.h"

/** Reflects the status of the eCall Notification.
 *<b>Since</b> SmartDeviceLink 2.0
 <p>
 */
typedef SDLEnum SDLECallConfirmationStatus SDL_SWIFT_ENUM;

/** No E-Call signal triggered.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusNormal;

/** An E-Call is being in progress.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusInProgress;

/** CALL_CANCELLED	An E-Call was cancelled by the user.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusCancelled;

/** The E-Call sequence is completed.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusCompleted;

/** An E-Call could not be connected.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusUnsuccessful;

/** E-Call is not configured on this vehicle.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusConfiguredOff;

/** E-Call is considered to be complete without Emergency Operator contact.
 */
extern SDLECallConfirmationStatus const SDLECallConfirmationStatusCompleteDTMFTimeout;
