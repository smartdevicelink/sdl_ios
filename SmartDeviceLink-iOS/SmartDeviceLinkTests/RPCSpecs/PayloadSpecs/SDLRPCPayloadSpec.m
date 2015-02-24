//
//  SDLRPCPayloadSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Jacob Keeler on 2/12/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCPayload.h"
#import "SDLRPCMessageType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLRPCPayloadSpec)

__block SDLRPCPayload* testPayload;
__block NSDictionary* dict = @{NAMES_response:
                                   @{NAMES_parameters:@{},
                                     NAMES_operation_name:NAMES_DeleteCommand}};

NSData* (^testData)() = ^NSData* {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:0];
    NSData* binaryData = [NSData dataWithBytes:"PrimitiveString" length:strlen("PrimitiveString")];
    
    UInt8 header[12] = {0x10, 0x00, 0x00, 0x06, 0x00, 0x00, 0x14, 0x43, 0x00, 0x00, 0x00, 0x00};
    *(UInt32 *)&header[8] = CFSwapInt32HostToBig((unsigned int)jsonData.length);
    
    NSMutableData *data = [NSMutableData dataWithCapacity:12 + jsonData.length];
    [data appendBytes:&header length:12];
    [data appendData:jsonData];
    [data appendData:binaryData];
    
    return data;
};

beforeSuite(^ {
    testPayload = [[SDLRPCPayload alloc] init];
    
    testPayload.rpcType = 0x01;
    testPayload.functionID = 0x06;
    testPayload.correlationID = 0x1443;
    testPayload.jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:0];
    testPayload.binaryData = [NSData dataWithBytes:"PrimitiveString" length:strlen("PrimitiveString")];
});

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        expect([NSNumber numberWithInteger:testPayload.rpcType]).to(equal(@0x01));
        expect([NSNumber numberWithInteger:testPayload.functionID]).to(equal(@0x06));
        expect([NSNumber numberWithInteger:testPayload.correlationID]).to(equal(@0x1443));
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
        SDLRPCPayload* constructedPayload = [SDLRPCPayload rpcPayloadWithData:testData()];
        
        expect([NSNumber numberWithInteger:constructedPayload.rpcType]).to(equal(@0x01));
        expect([NSNumber numberWithInteger:constructedPayload.functionID]).to(equal(@0x06));
        expect([NSNumber numberWithInteger:constructedPayload.correlationID]).to(equal(@0x1443));
        expect([NSJSONSerialization JSONObjectWithData:constructedPayload.jsonData options:0 error:0]).to(equal(dict));
        expect([NSString stringWithUTF8String:[constructedPayload binaryData].bytes]).to(equal(@"PrimitiveString"));
    });
});

QuickSpecEnd