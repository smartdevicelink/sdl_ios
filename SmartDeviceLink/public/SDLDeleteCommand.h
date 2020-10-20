/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


#import "SDLRPCRequest.h"

/**
 * Removes a command from the Command Menu
 * <p>
 * <b>HMI Status Requirements:</b><br/>
 * HMILevel: FULL, LIMITED or BACKGROUND<br/>
 * AudioStreamingState: N/A<br/>
 * SystemContext: Should not be attempted when VRSESSION or MENU
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLAddCommand SDLAddSubMenu SDLDeleteSubMenu
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteCommand : SDLRPCRequest

/**
 * @param cmdID - @(cmdID)
 * @return A SDLDeleteCommand object
 */
- (instancetype)initWithCmdID:(UInt32)cmdID;

/// Convenience init to remove a command from the menu
///
/// @param commandId The Command ID that identifies the Command to be deleted from Command Menu
/// @return An SDLDeleteCommand object
- (instancetype)initWithId:(UInt32)commandId __deprecated_msg("Use initWithCmdID: instead");

/**
 * the Command ID that identifies the Command to be deleted from Command Menu
 * @discussion an NSNumber value representing Command ID
 *            <p>
 *            <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *cmdID;

@end

NS_ASSUME_NONNULL_END
