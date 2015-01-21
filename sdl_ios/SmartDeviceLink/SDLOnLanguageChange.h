//  SDLOnLanguageChange.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLLanguage.h>

/**
 * Provides information to what language the Sync HMI language was changed
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
 * <th>Applink Ver Available</th>
 * </tr>
 * <tr>
 * <td>language</td>
 * <td> SDLLanguage * </td>
 * <td>Current SYNC voice engine (VR+TTS) language</td>
 * <td>Y</td>
 * <td></td>
 * <td>AppLink 2.0</td>
 * </tr>
 * <tr>
 * <td>hmiDisplayLanguage</td>
 * <td> SDLLanguage * </td>
 * <td>Current display language</td>
 * <td>Y</td>
 * <td></td>
 * <td>AppLink 2.0</td>
 * </tr>
 * </table>
 * </p>
 *
 */
@interface SDLOnLanguageChange : SDLRPCNotification {}

/**
 *Constructs a newly allocated SDLOnLanguageChange object
 */
-(id) init;
/**
 *<p>Constructs a newly allocated SDLOnLanguageChange object indicated by the NSMutableDictionary parameter</p>
 *@param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract language that current SYNC voice engine(VR+TTS) use
 * @discussion
 */
@property(strong) SDLLanguage* language;
/**
 * @abstract language that current display use
 * @discussion
 */
@property(strong) SDLLanguage* hmiDisplayLanguage;

@end
