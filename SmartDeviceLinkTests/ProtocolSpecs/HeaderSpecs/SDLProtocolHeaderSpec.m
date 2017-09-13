//
//  SDLProtocolHeaderSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLProtocolHeader.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolHeaderSpec)

describe(@"HeaderForVersion Tests", ^ {
    it(@"Should return the correct header", ^ {
        expect([SDLProtocolHeader headerForVersion:1]).to(beAKindOf(SDLV1ProtocolHeader.class));
        expect([SDLProtocolHeader headerForVersion:2]).to(beAKindOf(SDLV2ProtocolHeader.class));
    });
    
    it(@"Should return a v2 header for unknown version", ^ {
        expect([SDLProtocolHeader headerForVersion:255].version).to(equal(255));
    });
});

describe(@"DetermineVersion Tests", ^ {
    it(@"Should return the correct version", ^ {
        const char bytesV1[8] = {0x10 | SDLFrameType_First, SDLServiceType_BulkData, SDLFrameData_StartSessionACK, 0x5E, 0x00, 0x00, 0x00, 0x00};
        NSData* messageV1 = [NSData dataWithBytes:bytesV1 length:8];
        expect(@([SDLProtocolHeader determineVersion:messageV1])).to(equal(@1));

        const char bytesV2[12] = {0x20 | SDLFrameType_First, SDLServiceType_BulkData, SDLFrameData_StartSessionACK, 0x5E, 0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x44, 0x44};
        NSData* messageV2 = [NSData dataWithBytes:bytesV2 length:12];
        expect(@([SDLProtocolHeader determineVersion:messageV2])).to(equal(@2));
    });
});

QuickSpecEnd
