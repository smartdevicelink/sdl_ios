//  SDLPresetBankCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

/**
 * Contains information about on-screen preset capabilities.
 * <p><b>Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>AppLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>onScreenPresetsAvailable</td>
 * 			<td>Boolean</td>
 * 			<td>Defines, if Onscreen custom presets are available.
 * 			</td>
 * 			<td>AppLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since AppLink 2.0
 */
@interface SDLPresetBankCapabilities : SDLRPCStruct {}

/**
 * @abstract Constructs a newly allocated SDLPresetBankCapabilities object
 */
-(id) init;
/**
 * @abstract Constructs a newly allocated SDLPresetBankCapabilities object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract if Onscreen custom presets are available.
 */
@property(strong) NSNumber* onScreenPresetsAvailable;

@end
