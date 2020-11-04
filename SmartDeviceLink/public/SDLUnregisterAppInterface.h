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

NS_ASSUME_NONNULL_BEGIN

/**
 * Terminates an application's interface registration. This causes SDL&reg; to
 * dispose of all resources associated with the application's interface
 * registration (e.g. Command Menu items, Choice Sets, button subscriptions,
 * etc.)
 * <p>
 * After the UnregisterAppInterface operation is performed, no other operations
 * can be performed until a new app interface registration is established by
 * calling <i>{@linkplain RegisterAppInterface}</i>
 * <p>
 * <b>HMILevel can be FULL, LIMITED, BACKGROUND or NONE</b>
 * </p>
 *
 * See SDLRegisterAppInterface SDLOnAppInterfaceUnregistered
 *
 * @added in SmartDeviceLink 1.0.0
 */
@interface SDLUnregisterAppInterface : SDLRPCRequest

@end

NS_ASSUME_NONNULL_END
