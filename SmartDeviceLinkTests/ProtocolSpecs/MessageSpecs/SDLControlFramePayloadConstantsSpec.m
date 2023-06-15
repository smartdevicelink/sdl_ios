//
//  SDLControlFramePayloadConstantsSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLControlFramePayloadConstants.h"

QuickSpecBegin(SDLControlFramePayloadConstantsSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLControlFrameInt32NotFound).to(equal(-1));
        expect(SDLControlFrameInt64NotFound).to(equal(-1));

        expect(SDLControlFrameAuthTokenKey).to(equal(@"authToken"));
        expect(SDLControlFrameAudioServiceTransportsKey).to(equal(@"audioServiceTransports"));
        expect(SDLControlFrameHashIdKey).to(equal(@"hashId"));
        expect(SDLControlFrameHeightKey).to(equal(@"height"));
        expect(SDLControlFrameMTUKey).to(equal(@"mtu"));
        expect(SDLControlFrameProtocolVersionKey).to(equal(@"protocolVersion"));
        expect(SDLControlFrameReasonKey).to(equal(@"reason"));
        expect(SDLControlFrameRejectedParams).to(equal(@"rejectedParams"));
        expect(SDLControlFrameSecondaryTransportsKey).to(equal(@"secondaryTransports"));
        expect(SDLControlFrameTCPIPAddressKey).to(equal(@"tcpIpAddress"));
        expect(SDLControlFrameTCPPortKey).to(equal(@"tcpPort"));
        expect(SDLControlFrameVehicleHardwareVersionKey).to(equal(@"systemHardwareVersion"));
        expect(SDLControlFrameVehicleMakeKey).to(equal(@"make"));
        expect(SDLControlFrameVehicleModelKey).to(equal(@"model"));
        expect(SDLControlFrameVehicleModelYearKey).to(equal(@"modelYear"));
        expect(SDLControlFrameVehicleSoftwareVersionKey).to(equal(@"systemSoftwareVersion"));
        expect(SDLControlFrameVehicleTrimKey).to(equal(@"trim"));
        expect(SDLControlFrameVideoCodecKey).to(equal(@"videoCodec"));
        expect(SDLControlFrameVideoProtocolKey).to(equal(@"videoProtocol"));
        expect(SDLControlFrameVideoServiceTransportsKey).to(equal(@"videoServiceTransports"));
        expect(SDLControlFrameWidthKey).to(equal(@"width"));
    });
});

QuickSpecEnd


