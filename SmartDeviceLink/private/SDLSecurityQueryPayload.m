//
//  SDLSecurityQueryPayload.m
//  SmartDeviceLink
//
//  Created by Frank Elias on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLSecurityQueryPayload.h"

#import "SDLLogMacros.h"

const NSUInteger SECURITY_QUERY_HEADER_SIZE = 12;

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSecurityQueryPayload

+ (nullable id)securityPayloadWithData:(NSData *)data {
    return [[SDLSecurityQueryPayload alloc] initWithData:data];
}

- (nullable instancetype)initWithData:(NSData *)data {
    NSUInteger dataLength = data.length;

    if (data == nil || dataLength == 0) {
        SDLLogW(@"Security Payload data is nil");
        return nil;
    }

    if (dataLength < SECURITY_QUERY_HEADER_SIZE) {
        SDLLogE(@"Security Payload error: not enough data to form Security Query header");
        return nil;
    }

    self = [super init];
    if (!self) { return nil; }

    @try {
        // Setup our pointers for data access
        Byte *bytePointer = (UInt8 *)data.bytes;
        UInt32 *ui32Pointer = (UInt32 *)data.bytes;

        // Extract the parts
        UInt8 queryType = bytePointer[0];

        self.queryType = queryType;

        // Extract the 24 bit query ID in the last 24 bits of the first 32 bits.
        UInt32 queryID = ui32Pointer[0];
        queryID = CFSwapInt32BigToHost(queryID) & 0x00FFFFFF;
        self.queryID = queryID;

        // Extract the 32 bit sequence number from the data after the first 32 bits.
        UInt32 sequenceNumber = ui32Pointer[1];
        sequenceNumber = CFSwapInt32BigToHost(sequenceNumber);
        self.sequenceNumber = sequenceNumber;

        // Extract the 32 bit json data size from the data after the first 64 bits
        UInt32 jsonDataSize = ui32Pointer[2];
        jsonDataSize = CFSwapInt32BigToHost(jsonDataSize);

        // Extract the JSON data after the header (96 bits) based on the JSON data size
        NSData *jsonData = nil;
        NSUInteger offsetOfJSONData = SECURITY_QUERY_HEADER_SIZE;
        if (jsonDataSize > 0 && jsonDataSize <= dataLength - SECURITY_QUERY_HEADER_SIZE) {
            jsonData = [data subdataWithRange:NSMakeRange(offsetOfJSONData, jsonDataSize)];
        }
        self.jsonData = jsonData;

        // Extract the binary data after the header (96 bits) and the JSON data to the end
        NSData *binaryData = nil;
        NSUInteger offsetOfBinaryData = SECURITY_QUERY_HEADER_SIZE + jsonDataSize;
        NSUInteger binaryDataSize = data.length - jsonDataSize - SECURITY_QUERY_HEADER_SIZE;
        if (binaryDataSize > 0) {
            binaryData = [data subdataWithRange:NSMakeRange(offsetOfBinaryData, binaryDataSize)];
        }
        self.binaryData = binaryData;

    } @catch (NSException *e) {
        SDLLogE(@"SDLSecurityQueryPayload init error: %@", e);
        return nil;
    }

    return self;
}

- (NSData *)data {
    // From the properties, create a data buffer
    // Query Type - first 8 bits
    // Query ID - next 24 bits
    // Sequence Number - next 32 bits
    // JSON size - next 32 bits
    UInt8 headerBuffer[SECURITY_QUERY_HEADER_SIZE];
    *(UInt32 *)&headerBuffer[0] = CFSwapInt32HostToBig(self.queryID);
    *(UInt32 *)&headerBuffer[4] = CFSwapInt32HostToBig(self.sequenceNumber);
    *(UInt32 *)&headerBuffer[8] = CFSwapInt32HostToBig((UInt32)self.jsonData.length);
    headerBuffer[0] &= 0xFF;
    headerBuffer[0] |= self.queryType;

    // Serialize the header. Append the json data, then the binary data
    NSMutableData *dataOut = [NSMutableData dataWithCapacity:[self size]];
    [dataOut appendBytes:&headerBuffer length:12];
    [dataOut appendData:self.jsonData];
    [dataOut appendData:self.binaryData];

    return dataOut;
}

- (NSUInteger)size {
    NSUInteger jsonDataSize = self.jsonData.length;
    NSUInteger binaryDataSize = self.binaryData.length;

    return (SECURITY_QUERY_HEADER_SIZE + jsonDataSize + binaryDataSize);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Security Query Header: queryType:%i, queryID:%lu, sequenceNumber:%lu, json:%lu bytes, binary:%lu bytes", self.queryType, (unsigned long)self.queryID, (unsigned long)self.sequenceNumber, (NSUInteger)self.jsonData.length, (NSUInteger)self.binaryData.length];
}

@end

NS_ASSUME_NONNULL_END
