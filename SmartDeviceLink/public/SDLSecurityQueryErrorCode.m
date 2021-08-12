//
//  SDLSecurityQueryErrorCode.m
//  SmartDeviceLink
//
//  Created by Frank Elias on 8/12/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLSecurityQueryErrorCode.h"

SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SUCCESS = @"Internal Security Manager value";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INVALID_QUERY_SIZE = @"Wrong size of query data";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INVALID_QUERY_ID = @"Unknown Query ID";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_NOT_SUPPORTED = @"SDL does not support encryption";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SERVICE_ALREADY_PROTECTED = @"Received request to protect a service that was protected before";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SERVICE_NOT_PROTECTED = @"Received handshake or encrypted data for not protected service";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_DECRYPTION_FAILED = @"Decryption failed";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_ENCRYPTION_FAILED = @"Encryption failed";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SSL_INVALID_DATA = @"SSL invalid data";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_HANDSHAKE_FAILED = @"In case of all other handshake errors";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INVALID_CERT = @"Handshake failed because certificate is invalid";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_EXPIRED_CERT = @"Handshake failed because certificate is expired";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INTERNAL = @"Internal error";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_UNKNOWN_INTERNAL_ERROR = @"Error value for testing";
