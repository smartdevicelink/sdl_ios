//  SDLECallConfirmationStatus.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/** Reflects the status of the eCall Notification.
 *<b>Since</b> SmartDeviceLink 2.0
 <p>
 */

@interface SDLECallConfirmationStatus : SDLEnum {}

+(SDLECallConfirmationStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

/** No E-Call signal triggered.
 */

+(SDLECallConfirmationStatus*) NORMAL;

/** An E-Call is being in progress.
 */

+(SDLECallConfirmationStatus*) CALL_IN_PROGRESS;

/** CALL_CANCELLED	An E-Call was cancelled by the user.
 */

+(SDLECallConfirmationStatus*) CALL_CANCELLED;

/** The E-Call sequence is completed.
 */

+(SDLECallConfirmationStatus*) CALL_COMPLETED;

/** An E-Call could not be connected.
 */

+(SDLECallConfirmationStatus*) CALL_UNSUCCESSFUL;

/** E-Call is not configured on this vehicle.
 */

+(SDLECallConfirmationStatus*) ECALL_CONFIGURED_OFF;

/** E-Call is considered to be complete without Emergency Operator contact.
 */

+(SDLECallConfirmationStatus*) CALL_COMPLETE_DTMF_TIMEOUT;

@end
