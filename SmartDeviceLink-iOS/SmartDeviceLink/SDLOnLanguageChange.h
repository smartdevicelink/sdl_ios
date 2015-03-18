//  SDLOnLanguageChange.h
//


#import "SDLRPCNotification.h"

#import "SDLLanguage.h"

/**
 * Provides information to what language the SDL HMI language was changed
 * <p>
 * </p>
 * <b>HMI Status Requirements:</b>
 * <ul>
 * HMILevel:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * AudioStreamingState:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * SystemContext:
 * <ul>
 * <li>TBD</li>
 * </ul>
 * </ul>
 * <p>
 * <b>Parameter List:</b>
 * <table border="1" rules="all">
 * <tr>
 * <th>Name</th>
 * <th>Type</th>
 * <th>Description</th>
 * <th>Req</th>
 * <th>Notes</th>
 * <th>SmartDeviceLink Ver Available</th>
 * </tr>
 * <tr>
 * <td>language</td>
 * <td> SDLLanguage * </td>
 * <td>Current SDL voice engine (VR+TTS) language</td>
 * <td>Y</td>
 * <td></td>
 * <td>SmartDeviceLink 2.0</td>
 * </tr>
 * <tr>
 * <td>hmiDisplayLanguage</td>
 * <td> SDLLanguage * </td>
 * <td>Current display language</td>
 * <td>Y</td>
 * <td></td>
 * <td>SmartDeviceLink 2.0</td>
 * </tr>
 * </table>
 * </p>
 *
 */
@interface SDLOnLanguageChange : SDLRPCNotification {
}
/**
 *Constructs a newly allocated SDLOnLanguageChange object
 */
- (id)init;
/**
 *<p>Constructs a newly allocated SDLOnLanguageChange object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;
/**
 * @abstract language that current SDL voice engine(VR+TTS) use
 * @discussion
 */
@property (strong) SDLLanguage *language;
/**
 * @abstract language that current display use
 * @discussion
 */
@property (strong) SDLLanguage *hmiDisplayLanguage;
@end
