//  SDLParameterPermissions.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

/**
 * Defining sets of parameters, which are permitted or prohibited for a given RPC.
 * <p><b>Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>AppLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>allowed</td>
 * 			<td>String</td>
 * 			<td>A set of all parameters that are permitted for this given RPC.
 * 					<ul>
 *					<li>Min size: 0</li>
 *					<li>Max size: 100</li>
 *					<li>Max length: 100</li>
 *					</ul>
 * 			</td>
 * 			<td>AppLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>userDisallowed</td>
 * 			<td>String</td>
 * 			<td>A set of all parameters that are prohibated for this given RPC.
 * 					<ul>
 *					<li>Min size: 0</li>
 *					<li>Max size: 100</li>
 *					<li>Max length: 100</li>
 *					</ul>
 * 			</td>
 * 			<td>AppLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since AppLink 2.0
 */
@interface SDLParameterPermissions : SDLRPCStruct {}

/**
 *@abstract  Constructs a newly allocated SDLParameterPermissions object
 */
-(id) init;
/**
 * @abstract Constructs a newly allocated SDLParameterPermissions object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract A set of all parameters that are permitted for this given RPC.
 */
@property(strong) NSMutableArray* allowed;
/**
 * @abstract A set of all parameters that are prohibited for this given RPC.
 */
@property(strong) NSMutableArray* userDisallowed;

@end
