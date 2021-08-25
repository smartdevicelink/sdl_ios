//
//  SDLSecurityQueryErrorCode.m
//  SmartDeviceLink
//
//  Created by Frank Elias on 8/12/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLSecurityQueryErrorCode.h"

SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeSuccess = @"Success";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInvalidQuerySize = @"Wrong size of query data";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInvalidQueryID = @"Unknown Query ID";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeNotSupported = @"SDL does not support encryption";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeServiceAlreadyProtected = @"Received request to protect a service that was protected before";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeServiceNotProtected = @"Received handshake or encrypted data for not protected service";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeDecryptionFailed = @"Decryption failed";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeEncryptionFailed = @"Encryption failed";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeSSLInvalidData = @"SSL invalid data";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeHandshakeFailed = @"In case of all other handshake errors";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInvalidCertificate = @"Handshake failed because certificate is invalid";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeExpiredCertificate = @"Handshake failed because certificate is expired";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInternal = @"Internal error";
SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeUnknownInternalError = @"Error value for testing";
