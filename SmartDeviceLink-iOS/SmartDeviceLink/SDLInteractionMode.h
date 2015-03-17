//  SDLInteractionMode.h
//



#import "SDLEnum.h"

/**
 * For application-initiated interactions (<i>PerformInteraction</i>), this specifies
 * the mode by which the user is prompted and by which the user's selection is
 * indicated
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLInteractionMode : SDLEnum {}

/*!
 @abstract return SDLInteractionMode (Manual / VR / Both)
 @param value NSString
 @result return SDLInteractionMode
 */
+(SDLInteractionMode*) valueOf:(NSString*) value;
/*!
 @abstract store all possible SDLInteractionMode values
 @result return an array with all possible SDLInteractionMode values inside
 */
+(NSMutableArray*) values;

/**
 * @abstract Interaction Mode : Manual Only
 * @discussion This mode causes the interaction to occur only on the display, meaning
 * the choices are presented and selected only via the display. Selections
 * are viewed with the SEEKRIGHT, SEEKLEFT, TUNEUP, TUNEDOWN buttons. User's
 * selection is indicated with the OK button
 *
 * @result return current Interaction Mode with value of <font color=gray><i> MANUAL_ONLY </i></font>
 */
+(SDLInteractionMode*) MANUAL_ONLY;
/**
 * @abstract Interaction Mode : VR Only
 * @discussion This mode causes the interaction to occur only through TTS and VR. The
 * user is prompted via TTS to select a choice by saying one of the choice's
 * synonyms
 *
 * @result return current Interaction Mode with value of <font color=gray><i> VR_ONLY </i></font>
 */
+(SDLInteractionMode*) VR_ONLY;
/**
 * @abstract Interaction Mode : Manual & VR
 * @discussion This mode is a combination of MANUAL_ONLY and VR_ONLY, meaning the user
 * is prompted both visually and audibly. The user can make a selection
 * either using the mode described in MANUAL_ONLY or using the mode
 * described in VR_ONLY. If the user views selections as described in
 * MANUAL_ONLY mode, the interaction becomes strictly, and irreversibly, a
 * MANUAL_ONLY interaction (i.e. the VR session is cancelled, although the
 * interaction itself is still in progress). If the user interacts with the
 * VR session in any way (e.g. speaks a phrase, even if it is not a
 * recognized choice), the interaction becomes strictly, and irreversibly, a
 * VR_ONLY interaction (i.e. the MANUAL_ONLY mode forms of interaction will
 * no longer be honored)
 * <P>
 * The TriggerSource parameter of the
 * <i>PerformInteraction</i> response will
 * indicate which interaction mode the user finally chose to attempt the
 * selection (even if the interaction did not end with a selection being
 * made)
 *
 *@result return current Interaction Mode with value of <font color=gray><i> BOTH </i></font>
 */
+(SDLInteractionMode*) BOTH;

@end
