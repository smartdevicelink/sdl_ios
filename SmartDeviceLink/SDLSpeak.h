//  SDLSpeak.h
//

#import "SDLRPCRequest.h"

@class SDLTTSChunk;

/**
 * Speaks a phrase over the vehicle audio system using SDL's TTS (text-to-speech) engine. The provided text to be spoken can be simply a text phrase, or it can consist of phoneme specifications to direct SDL's TTS engine to speak a "speech-sculpted" phrase.
 *
 * Receipt of the Response indicates the completion of the Speak operation, regardless of how the Speak operation may have completed (i.e. successfully, interrupted, terminated, etc.).
 *
 * Requesting a new Speak operation while the application has another Speak operation already in progress (i.e. no corresponding Response for that in-progress Speak operation has been received yet) will terminate the in-progress Speak operation (causing its corresponding Response to be sent by SDL) and begin the requested Speak operation
 *
 * Requesting a new Speak operation while the application has an <i>SDLAlert</i> operation already in progress (i.e. no corresponding Response for that in-progress <i>SDLAlert</i> operation has been received yet) will result in the Speak operation request being rejected (indicated in the Response to the Request)
 *
 * Requesting a new <i>SDLAlert</i> operation while the application has a Speak operation already in progress (i.e. no corresponding Response for that in-progress Speak operation has been received yet) will terminate the in-progress Speak operation (causing its corresponding Response to be sent by SDL) and begin the requested <i>SDLAlert</i> operation
 *
 * Requesting a new Speak operation while the application has a <i>SDLPerformInteraction</i> operation already in progress (i.e. no corresponding Response for that in-progress <i>SDLPerformInteraction</i> operation has been received yet) will result in the Speak operation request being rejected (indicated in the Response to the Request)
 *
 * Requesting a <i>SDLPerformInteraction</i> operation while the application has a Speak operation already in progress (i.e. no corresponding Response for that in-progress Speak operation has been received yet) will terminate the in-progress Speak operation (causing its corresponding Response to be sent by SDL) and begin the requested <i>SDLPerformInteraction</i> operation
 *
 * HMI Status Requirements:
 * <li>HMILevel: FULL, Limited</li>
 * <li>AudioStreamingState: Any</li>
 * <li>SystemContext: MAIN, MENU, VR</li>
 
 * <b>Notes:</b>
 * <li>When <i>SDLAlert</i> is issued with MENU in effect, <i>SDLAlert</i> is queued and "played" when MENU interaction is completed (i.e. SystemContext reverts to MAIN). When <i>SDLAlert
 * </i> is issued with VR in effect, <i>SDLAlert</i> is queued and "played" when VR interaction is completed (i.e. SystemContext reverts to MAIN)</li>
 * <li>When both <i>SDLAlert</i> and Speak are queued during MENU or VR, they are "played" back in the order in which they were queued, with all existing rules for "collisions" still in effect</li>
 *
 * <b>Additional Notes:</b>
 * <li>Total character limit depends on platform.</li>
 * <li>Chunks are limited to 500 characters; however you can have multiple TTS chunks.</li>
 * <li>On old systems there is a total character limit of 500 characters across all chunks. This could vary according to the VCA.</li>
 *
 * @since SmartDeviceLink 1.0
 * @see SDLAlert
 */
@interface SDLSpeak : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSpeak object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLSpeak object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithTTS:(NSString *)ttsText;

- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks;

/**
 * @abstract An array of TTSChunk structs which, taken together, specify the phrase to be spoken
 *
 * @discussion The total length of the phrase composed from the ttsChunks provided must be less than 500 characters or the request will be rejected
 * 
 * Required, Array of SDLTTSChunk, Array size 1 - 100
 * 
 * @see SDLTTSChunk
 */
@property (strong) NSMutableArray *ttsChunks;

@end
