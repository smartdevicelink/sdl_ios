//
//  SDLProtocolConstants.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/1/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt8, SDLFrameType) {
    SDLFrameTypeControl = 0x00,
    SDLFrameTypeSingle = 0x01,
    SDLFrameTypeFirst = 0x02,
    SDLFrameTypeConsecutive = 0x03
};

typedef NS_ENUM(UInt8, SDLServiceType) {
    SDLServiceTypeControl = 0x00,
    SDLServiceTypeRPC NS_SWIFT_NAME(rpc) = 0x07,
    SDLServiceTypeAudio = 0x0A,
    SDLServiceTypeVideo = 0x0B,
    SDLServiceTypeBulkData = 0x0F
};

typedef NS_ENUM(UInt8, SDLFrameInfo) {
    SDLFrameInfoHeartbeat = 0x00,
    SDLFrameInfoStartService = 0x01,
    SDLFrameInfoStartServiceACK = 0x02,
    SDLFrameInfoStartServiceNACK = 0x03,
    SDLFrameInfoEndService = 0x04,
    SDLFrameInfoEndServiceACK = 0x05,
    SDLFrameInfoEndServiceNACK = 0x06,
    SDLFrameInfoServiceDataAck = 0xFE,
    SDLFrameInfoHeartbeatACK = 0xFF,
    // If frameType == Single (0x01)
    SDLFrameInfoSingleFrame = 0x00,
    // If frameType == First (0x02)
    SDLFrameInfoFirstFrame = 0x00,
    // If frametype == Consecutive (0x03)
    SDLFrameInfoConsecutiveLastFrame = 0x00
};
