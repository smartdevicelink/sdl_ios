//  SDLSpeak.h
//



#import "SDLRPCRequest.h"

/**
 * Speaks a phrase over the vehicle audio system using SDL's TTS
 * (text-to-speech) engine. The provided text to be spoken can be simply a text
 * phrase, or it can consist of phoneme specifications to direct SDL's TTS
 * engine to speak a "speech-sculpted" phrase
 * <p>
 * Receipt of the Response indicates the completion of the Speak operation,
 * regardless of how the Speak operation may have completed (i.e. successfully,
 * interrupted, terminated, etc.)
 * <p>
 * Requesting a new Speak operation while the application has another Speak
 * operation already in progress (i.e. no corresponding Response for that
 * in-progress Speak operation has been received yet) will terminate the
 * in-progress Speak operation (causing its corresponding Response to be sent by
 * SDL) and begin the requested Speak operation
 * <p>
 * Requesting a new Speak operation while the application has an <i>
 * SDLAlert</i> operation already in progress (i.e. no corresponding
 * Response for that in-progress <i>SDLAlert</i> operation has been
 * received yet) will result in the Speak operation request being rejected
 * (indicated in the Response to the Request)
 * <p>
 * Requesting a new <i>SDLAlert</i> operation while the application
 * has a Speak operation already in progress (i.e. no corresponding Response for
 * that in-progress Speak operation has been received yet) will terminate the
 * in-progress Speak operation (causing its corresponding Response to be sent by
 * SDL) and begin the requested <i>SDLAlert</i> operation
 * <p>
 * Requesting a new Speak operation while the application has a <i>
 * SDLPerformInteraction</i> operation already in progress (i.e. no
 * corresponding Response for that in-progress <i>
 * SDLPerformInteraction</i> operation has been received yet) will
 * result in the Speak operation request being rejected (indicated in the
 * Response to the Request)
 * <p>
 * Requesting a <i> SDLPerformInteraction</i> operation while the
 * application has a Speak operation already in progress (i.e. no corresponding
 * Response for that in-progress Speak operation has been received yet) will
 * terminate the in-progress Speak operation (causing its corresponding Response
 * to be sent by SDL) and begin the requested <i>
 * SDLPerformInteraction</i> operation
 * <p>
 *
 * <b>HMI Status Requirements:</b><br/>
 * HMILevel: FULL, Limited<br/>
 * AudioStreamingState: Any<br/>
 * SystemContext: MAIN, MENU, VR
 * </p>
 * <b>Notes: </b>
 * <ul>
 * <li>When <i>SDLAlert</i> is issued with MENU in effect, <i>
 * SDLAlert</i> is queued and "played" when MENU interaction is
 * completed (i.e. SystemContext reverts to MAIN). When <i>SDLAlert
 * </i> is issued with VR in effect, <i>SDLAlert</i> is queued and
 * "played" when VR interaction is completed (i.e. SystemContext reverts to
 * MAIN)</li>
 * <li>When both <i>SDLAlert</i> and Speak are queued during MENU or
 * VR, they are "played" back in the order in which they were queued, with all
 * existing rules for "collisions" still in effect</li>
 * </ul>
 * <p>
 * <b>Additional Notes:</b><br><ul>Total character limit depends on platform.
 * Chunks are limited to 500 characters; however you can have multiple TTS chunks.
 * On Gen 1.1 there is a total character limit of 500 characters across all chunks. This could vary according to the VCA.
 * <p>
 *
 * Since SmartDeviceLink 1.0<br/>
 * See SDLAlert
 */
@interface SDLSpeak : SDLRPCRequest {}

/**
 * @abstract Constructs a new SDLSpeak object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLSpeak object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract A Vector<TTSChunk> representing an array of 1-100 TTSChunk structs
 * which, taken together, specify the phrase to be spoken
 *
 * @discussion A Vector<TTSChunk> value representing an array of 1-100 TTSChunk structs
 * which specify the phrase to be spoken
 *            <p>
 *            <ul>
 *            <li>The array must have 1-100 elements</li>
 *            <li>The total length of the phrase composed from the ttsChunks
 *            provided must be less than 500 characters or the request will
 *            be rejected</li>
 *            <li>Each chunk can be no more than 500 characters</li>
 *            </ul>
 */
@property(strong) NSMutableArray* ttsChunks;

@end

