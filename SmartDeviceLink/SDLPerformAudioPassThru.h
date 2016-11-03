//  SDLPerformAudioPassThru.h
//

#import "SDLRPCRequest.h"

@class SDLSamplingRate;
@class SDLBitsPerSample;
@class SDLAudioType;


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
@interface SDLPerformAudioPassThru : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLPerformAudioPassThru object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLPerformAudioPassThru object indicated by the NSMutableDictionary
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithSamplingRate:(SDLSamplingRate *)samplingRate bitsPerSample:(SDLBitsPerSample *)bitsPerSample audioType:(SDLAudioType *)audioType maxDuration:(UInt32)maxDuration;

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt audioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate *)samplingRate bitsPerSample:(SDLBitsPerSample *)bitsPerSample audioType:(SDLAudioType *)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio;

/**
 * @abstract initial prompt which will be spoken before opening the audio pass
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
@property (strong) NSMutableArray *initialPrompt;
/**
 * @abstract a line of text displayed during audio capture
 * @discussion audioPassThruDisplayText1
 *            a String value representing the line of text displayed during
 *            audio capture
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (strong) NSString *audioPassThruDisplayText1;
/**
 * @abstract A line of text displayed during audio capture
 * @discussion audioPassThruDisplayText2
 *            a String value representing the line of text displayed during
 *            audio capture
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (strong) NSString *audioPassThruDisplayText2;
/**
 * @abstract A samplingRate
 *
 * @discussion a SamplingRate value representing a 8 or 16 or 22 or 24 khz
 */
@property (strong) SDLSamplingRate *samplingRate;
/**
 * @abstract the maximum duration of audio recording in milliseconds
 *
 * @discussion maxDuration
 *            an Integer value representing the maximum duration of audio
 *            recording in millisecond
 *            <p>
 *            <b>Notes: </b>Minvalue:1; Maxvalue:1000000
 */
@property (strong) NSNumber *maxDuration;
/**
 * @abstract the quality the audio is recorded - 8 bit or 16 bit
 *
 * @discussion a BitsPerSample value representing 8 bit or 16 bit
 */
@property (strong) SDLBitsPerSample *bitsPerSample;
/**
 * @abstract an audioType
 */
@property (strong) SDLAudioType *audioType;
/**
 * @abstract a Boolean value representing if the current audio source should be
 * muted during the APT session<br/>
 */
@property (strong) NSNumber *muteAudio;

@end
