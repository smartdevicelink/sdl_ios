//
//  SDLControlFramePayloadConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFramePayloadConstants.h"

int32_t const SDLControlFrameInt32NotFound = -1;
int64_t const SDLControlFrameInt64NotFound = -1;

char *const SDLControlFrameProtocolVersionKey = "protocolVersion";
char *const SDLControlFrameHashIdKey = "hashId";
char *const SDLControlFrameMTUKey = "mtu";
char *const SDLControlFrameRejectedParams = "rejectedParams";
char *const SDLControlFrameVideoProtocolKey = "videoProtocol";
char *const SDLControlFrameVideoCodecKey = "videoCodec";
char *const SDLControlFrameHeightKey = "height";
char *const SDLControlFrameWidthKey = "width";
char *const SDLControlFrameSecondaryTransportsKey = "secondaryTransports";
char *const SDLControlFrameAudioServiceTransportsKey = "audioServiceTransports";
char *const SDLControlFrameVideoServiceTransportsKey = "videoServiceTransports";
char *const SDLControlFrameTCPIPAddressKey = "tcpIpAddress";
char *const SDLControlFrameTCPPortKey = "tcpPort";
