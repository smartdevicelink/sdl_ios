//  SDLPerformAudioPassThru.h
//

#import "SDLRPCRequest.h"

#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLNotificationConstants.h"
#import "SDLSamplingRate.h"

@class SDLTTSChunk;

/**
 * This will open an audio pass thru session. By doing so the app can receive
 * audio data through the vehicle microphone
 * <p>
 * Function Group: AudioPassThru
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * <p>Since SmartDeviceLink 2.0</p>
 * <p>See SDLEndAudioPassThru</p>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLPerformAudioPassThru : SDLRPCRequest

/// Convenience init to perform an audio pass thru
///
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration;

/// Convenience init to perform an audio pass thru
///
/// @param initialPrompt Initial prompt which will be spoken before opening the audio pass thru session by SDL
/// @param audioPassThruDisplayText1 A line of text displayed during audio capture
/// @param audioPassThruDisplayText2 A line of text displayed during audio capture
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
/// @param muteAudio A Boolean value representing if the current audio source should be muted during the APT session
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio;

/// Convenience init to perform an audio pass thru
///
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
/// @param audioDataHandler A handler that will be called whenever an onAudioPassThru notification is received.
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration audioDataHandler:(nullable SDLAudioPassThruHandler)audioDataHandler;

/// Convenience init for a perform audio pass thru
///
// @param initialPrompt Initial prompt which will be spoken before opening the audio pass thru session by SDL
/// @param audioPassThruDisplayText1 A line of text displayed during audio capture
/// @param audioPassThruDisplayText2 A line of text displayed during audio capture
/// @param samplingRate A samplingRate
/// @param bitsPerSample The quality the audio is recorded - 8 bit or 16 bit
/// @param audioType An audioType
/// @param maxDuration The maximum duration of audio recording in milliseconds
/// @param muteAudio A Boolean value representing if the current audio source should be muted during the APT session
/// @param audioDataHandler A handler that will be called whenever an onAudioPassThru notification is received.
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio audioDataHandler:(nullable SDLAudioPassThruHandler)audioDataHandler;
    
/**
 * initial prompt which will be spoken before opening the audio pass
 * thru session by SDL
 * @discussion initialPrompt
 *            a Vector<TTSChunk> value represents the initial prompt which
 *            will be spoken before opening the audio pass thru session by
 *            SDL
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>This is an array of text chunks of type TTSChunk</li>
 *            <li>The array must have at least one item</li>
 *            <li>If omitted, then no initial prompt is spoken</li>
 *            <li>Array Minsize: 1</li>
 *            <li>Array Maxsize: 100</li>
 *            </ul>
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *initialPrompt;
/**
 * a line of text displayed during audio capture
 * @discussion audioPassThruDisplayText1
 *            a String value representing the line of text displayed during
 *            audio capture
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (nullable, strong, nonatomic) NSString *audioPassThruDisplayText1;
/**
 * A line of text displayed during audio capture
 * @discussion audioPassThruDisplayText2
 *            a String value representing the line of text displayed during
 *            audio capture
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (nullable, strong, nonatomic) NSString *audioPassThruDisplayText2;
/**
 * A samplingRate
 *
 * @discussion a SamplingRate value representing a 8 or 16 or 22 or 24 khz
 */
@property (strong, nonatomic) SDLSamplingRate samplingRate;
/**
 * the maximum duration of audio recording in milliseconds
 *
 * @discussion maxDuration
 *            an Integer value representing the maximum duration of audio
 *            recording in millisecond
 *            <p>
 *            <b>Notes: </b>Minvalue:1; Maxvalue:1000000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maxDuration;
/**
 * the quality the audio is recorded - 8 bit or 16 bit
 *
 * @discussion a BitsPerSample value representing 8 bit or 16 bit
 */
@property (strong, nonatomic) SDLBitsPerSample bitsPerSample;
/**
 * an audioType
 */
@property (strong, nonatomic) SDLAudioType audioType;
/**
 * a Boolean value representing if the current audio source should be
 * muted during the APT session<br/>
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *muteAudio;
    
/**
 *  A handler that will be called whenever an `onAudioPassThru` notification is received.
 */
@property (strong, nonatomic, nullable) SDLAudioPassThruHandler audioDataHandler;


@end

NS_ASSUME_NONNULL_END
