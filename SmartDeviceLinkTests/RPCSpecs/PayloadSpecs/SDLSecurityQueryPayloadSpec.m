//
//  SDLSecurityQueryPayloadSpec.m
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
#import "SDLSecurityQueryErrorCode.h"

QuickSpecBegin(SDLSecurityQueryPayloadSpec)

__block SDLSecurityQueryPayload* testPayload;
__block NSDictionary* dict = @{@"id": @"3", @"text": @"SDL does not support encryption"};

NSData* (^testData)(void) = ^NSData* {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:0];
    NSData* binaryData = [NSData dataWithBytes:"PrimitiveString" length:strlen("PrimitiveString")];

    Byte header[12] = {0x20, 0x00, 0x00, 0x02, 0x00, 0x00, 0x14, 0x43, 0x00, 0x00, 0x00, 0x00};
    *(UInt32 *)&header[8] = CFSwapInt32HostToBig((unsigned int)jsonData.length);

    NSMutableData *data = [NSMutableData dataWithCapacity:12 + jsonData.length];
    [data appendBytes:&header length:12];
    [data appendData:jsonData];
    [data appendData:binaryData];

    return data;
};

beforeSuite(^{
    testPayload = [[SDLSecurityQueryPayload alloc] init];

    testPayload.queryType = 0x20;
    testPayload.queryID = 0x02;
    testPayload.sequenceNumber = 0x1443;
    testPayload.jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:0];
    testPayload.binaryData = [NSData dataWithBytes:"PrimitiveString" length:strlen("PrimitiveString")];
});

describe(@"Getter/Setter Tests", ^ {
    it(@"should set and get correctly", ^ {
        expect(@(testPayload.queryType)).to(equal(SDLSecurityQueryTypeNotification));
        expect(@(testPayload.queryID)).to(equal(SDLSecurityQueryIdSendInternalError));
        expect(@(testPayload.sequenceNumber)).to(equal(@0x1443));
        expect([NSJSONSerialization JSONObjectWithData:testPayload.jsonData options:0 error:0]).to(equal(dict));
        expect([NSString stringWithUTF8String:[testPayload binaryData].bytes]).to(equal(@"PrimitiveString"));
    });
});

describe(@"Data Tests", ^ {
    it(@"should convert to byte data correctly", ^ {
        expect(testPayload.convertToData).to(equal(testData()));
    });
});

describe(@"RPCPayloadWithData Test", ^ {
    it(@"should convert from byte data correctly", ^ {
        SDLSecurityQueryPayload* constructedPayload = [SDLSecurityQueryPayload securityPayloadWithData:testData()];

        expect(@(constructedPayload.queryType)).to(equal(SDLSecurityQueryTypeNotification));
        expect(@(constructedPayload.queryID)).to(equal(SDLSecurityQueryIdSendInternalError));
        expect(@(constructedPayload.sequenceNumber)).to(equal(@0x1443));
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:constructedPayload.jsonData options:0 error:0];
        expect(jsonDict).to(equal(dict));
        expect(jsonDict[@"text"]).to(equal(SDLSecurityQueryErrorCodeNotSupported));
        expect([NSString stringWithUTF8String:[constructedPayload binaryData].bytes]).to(equal(@"PrimitiveString"));
    });
});

QuickSpecEnd
