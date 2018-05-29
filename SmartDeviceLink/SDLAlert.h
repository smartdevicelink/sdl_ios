//  SDLAlert.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;
@class SDLTTSChunk;

/**
 * Shows an alert which typically consists of text-to-speech message and text on the display. At least either alertText1, alertText2 or TTSChunks need to be provided.
 *
 * <ul>
 * <li>The displayed portion of the SDLAlert, if any, will persist until the
 * specified timeout has elapsed, or the SDLAlert is preempted</li>
 * <li>An SDLAlert will preempt (abort) any SmartDeviceLink Operation that is in-progress,
 * except an already-in-progress SDLAlert</li>
 * <li>An SDLAlert cannot be preempted by any SmartDeviceLink Operation</li>
 * <li>An SDLAlert can be preempted by a user action (button push)</li>
 * <li>An SDLAlert will fail if it is issued while another SDLAlert is in progress</li>
 * <li>Although each Alert parameter is optional, in fact each SDLAlert request
 * must supply at least one of the following parameters:<br/>
 * <ul>
 * <li>alertText1</li>
 * <li>alertText2</li>
 * <li>alertText3</li>
 * <li>ttsChunks</li>
 * </ul>
 * </li>
 * </ul>
 * <br/>
 * <b>HMILevel needs to be FULL or LIMITED.</b><br/>
 * <b>If the app has been granted function group Notification the SDLHMILevel can
 * also be BACKGROUND</b><br/>
 *
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlert : SDLRPCRequest


- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 duration:(UInt16)duration;

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3;

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration;

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

- (instancetype)initWithTTS:(nullable NSString *)ttsText playTone:(BOOL)playTone;

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 playTone:(BOOL)playTone duration:(UInt16)duration;

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration;

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone;

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;


/**
 * The String to be displayed in the first field of the display during the Alert
 *
 * @discussion Length is limited to what is indicated in *SDLRegisterAppInterface* response
 *
 * If omitted, top display line will be cleared
 * 
 * Text is always centered
 *
 * Optional, Max length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *alertText1;

/**
 * The String to be displayed in the second field of the display during the Alert
 *
 * @discussion Only permitted if HMI supports a second display line
 * 
 * Length is limited to what is indicated in *SDLRegisterAppInterface* response
 * 
 * If omitted, second display line will be cleared
 * 
 * Text is always centered
 *
 * Optional, Max length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *alertText2;

/**
 * the String to be displayed in the third field of the display during the Alert
 * @discussion Only permitted if HMI supports a third display line
 * 
 * Length is limited to what is indicated in *SDLRegisterAppInterface* response
 * 
 * If omitted, third display line will be cleared
 * 
 * Text is always centered
 *
 * Optional, Max length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *alertText3;

/**
 * An array which, taken together, specify what is to be spoken to the user
 *
 * Optional, Array of SDLTTSChunk, Array length 1 - 100
 *
 * @see SDLTTSChunk
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *ttsChunks;

/**
 * The duration of the displayed portion of the alert, in milliseconds.
 * 
 * @discussion After this amount of time has passed, the display fields alertText1 and alertText2 will revert to what was displayed in those fields before the alert began.
 *
 * Typical timeouts are 3 - 5 seconds
 *
 * If omitted, the timeout is set to 5 seconds
 * 
 * Optional, Integer, 3000 - 10000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *duration;

/**
 * Whether the alert tone should be played before the TTS (if any) is spoken.
 *
 * @discussion If ommitted, no tone is played
 * 
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *playTone;

/**
 * If supported on the given platform, the alert GUI will include some sort of animation indicating that loading of a feature is progressing.  e.g. a spinning wheel or hourglass, etc.
 * 
 * Optional, Boolean
 *
 * @since SmartDeviceLink 2.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *progressIndicator;

/**
 * App defined SoftButtons.
 *
 * @discussion If omitted on supported displays, the displayed alert shall not have any SoftButtons
 *
 * Optional, Array of SDLSoftButton, Array size 0 - 4
 *
 * @see SDLSoftButton
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
