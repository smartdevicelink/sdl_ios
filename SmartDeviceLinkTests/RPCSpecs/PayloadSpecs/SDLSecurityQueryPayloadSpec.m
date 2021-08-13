//
//  SDLsss.m
//  SmartDeviceLinkTests
//
//  Created by Frank Elias on 8/12/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSecurityQueryPayload.h"

QuickSpecBegin(SDLSecurityQueryPayloadSpec)

__block SDLSecurityQueryPayload* testPayload;
__block NSDictionary* dict = @{SDLRPCParameterNameResponse:
                                   @{SDLRPCParameterNameParameters:@{},
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameDeleteCommand}};

NSData* (^testData)(void) = ^NSData* {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:0];
    NSData* binaryData = [NSData dataWithBytes:"PrimitiveString" length:strlen("PrimitiveString")];

    UInt8 header[12] = {0x01, 0x00, 0x00, 0x06, 0x00, 0x00, 0x14, 0x43, 0x00, 0x00, 0x00, 0x00};
    *(UInt32 *)&header[8] = CFSwapInt32HostToBig((unsigned int)jsonData.length);

    NSMutableData *data = [NSMutableData dataWithCapacity:12 + jsonData.length];
    [data appendBytes:&header length:12];
    [data appendData:jsonData];
    [data appendData:binaryData];

    return data;
};

beforeSuite(^ {
    testPayload = [[SDLSecurityQueryPayload alloc] init];

    testPayload.queryType = 0x01;
    testPayload.queryID = 0x06;
    testPayload.sequenceNumber = 0x1443;
    testPayload.jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:0];
    testPayload.binaryData = [NSData dataWithBytes:"PrimitiveString" length:strlen("PrimitiveString")];
});

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        expect(@(testPayload.queryType)).to(equal(@0x01));
        expect(@(testPayload.queryID)).to(equal(@0x06));
        expect(@(testPayload.sequenceNumber)).to(equal(@0x1443));
        expect([NSJSONSerialization JSONObjectWithData:testPayload.jsonData options:0 error:0]).to(equal(dict));
        expect([NSString stringWithUTF8String:[testPayload binaryData].bytes]).to(equal(@"PrimitiveString"));
    });
});

describe(@"Data Tests", ^ {
    it (@"Should convert to byte data correctly", ^ {
        expect(testPayload.data).to(equal(testData()));
    });
});

describe(@"RPCPayloadWithData Test", ^ {
    it (@"Should convert from byte data correctly", ^ {
        SDLSecurityQueryPayload* constructedPayload = [SDLSecurityQueryPayload securityPayloadWithData:testData()];

        expect(@(constructedPayload.queryType)).to(equal(@0x01));
        expect(@(constructedPayload.queryID)).to(equal(@0x06));
        expect(@(constructedPayload.sequenceNumber)).to(equal(@0x1443));
        expect([NSJSONSerialization JSONObjectWithData:constructedPayload.jsonData options:0 error:0]).to(equal(dict));
        expect([NSString stringWithUTF8String:[constructedPayload binaryData].bytes]).to(equal(@"PrimitiveString"));
    });
});

QuickSpecEnd
