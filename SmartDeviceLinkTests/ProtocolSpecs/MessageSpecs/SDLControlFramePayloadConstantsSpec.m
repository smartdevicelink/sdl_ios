//
//  SDLControlFramePayloadConstantsSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"

QuickSpecBegin(SDLControlFramePayloadConstantsSpec)

describe(@"individual enum value tests", ^ {
    it(@"should match internal values", ^ {
        expect(SDLControlFrameInt32NotFound).to(equal(-1));
        expect(SDLControlFrameInt64NotFound).to(equal(-1));
        expect(SDLControlFrameProtocolVersionKey).to(equal(@"protocolVersion"));
        expect(SDLControlFrameHashIdKey).to(equal(@"hashId"));
        expect(SDLControlFrameMTUKey).to(equal(@"mtu"));
        expect(SDLControlFrameSecondaryTransportsKey).to(equal(@"secondaryTransports"));
        expect(SDLControlFrameAudioServiceTransportsKey).to(equal(@"audioServiceTransports"));
        expect(SDLControlFrameVideoServiceTransportsKey).to(equal(@"videoServiceTransports"));
        expect(SDLControlFrameAuthTokenKey).to(equal(@"authToken"));
        expect(SDLControlFrameRejectedParams).to(equal(@"rejectedParams"));
        expect(SDLControlFrameReasonKey).to(equal(@"reason"));
        expect(SDLControlFrameVideoProtocolKey).to(equal(@"videoProtocol"));
        expect(SDLControlFrameVideoCodecKey).to(equal(@"videoCodec"));
        expect(SDLControlFrameHeightKey).to(equal(@"height"));
        expect(SDLControlFrameWidthKey).to(equal(@"width"));
        expect(SDLControlFrameTCPIPAddressKey).to(equal(@"tcpIpAddress"));
        expect(SDLControlFrameTCPPortKey).to(equal(@"tcpPort"));
        expect(SDLControlFrameVehicleHardVersion).to(equal("systemHardwareVersion"));
        expect(strcmp("systemHardwareVersion", SDLControlFrameVehicleHardVersion)).to(equal(0));
        expect(SDLControlFrameVehicleMake).to(equal("make"));
        expect(strcmp("make", SDLControlFrameVehicleMake)).to(equal(0));
        expect(SDLControlFrameVehicleModel).to(equal("model"));
        expect(strcmp("model", SDLControlFrameVehicleModel)).to(equal(0));
        expect(SDLControlFrameVehicleModelYear).to(equal("modelYear"));
        expect(strcmp("modelYear", SDLControlFrameVehicleModelYear)).to(equal(0));
        expect(SDLControlFrameVehicleSoftVersion).to(equal("systemSoftwareVersion"));
        expect(strcmp("systemSoftwareVersion", SDLControlFrameVehicleSoftVersion)).to(equal(0));
        expect(SDLControlFrameVehicleTrim).to(equal("trim"));
        expect(strcmp("trim", SDLControlFrameVehicleTrim)).to(equal(0));
    });
});

QuickSpecEnd
