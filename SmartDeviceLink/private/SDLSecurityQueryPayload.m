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

- (nullable instancetype)initWithData:(NSData *)data {
    if (data == nil || data.length < SECURITY_QUERY_HEADER_SIZE) {
        SDLLogE(@"Security Payload error: not enough data to form Security Query header. Data length: %lu", (unsigned long)data.length);
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
        if (jsonDataSize > 0 && jsonDataSize <= (data.length - SECURITY_QUERY_HEADER_SIZE)) {
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

- (instancetype)initWithQueryType:(SDLSecurityQueryType)queryType queryID:(SDLSecurityQueryId)queryID sequenceNumber:(UInt32)sequenceNumber jsonData:(nullable NSData *)jsonData binaryData:(nullable NSData *)binaryData {
    self = [super init];
    if (!self) { return nil; }

    _queryType = queryType;
    _queryID = queryID;
    _sequenceNumber = sequenceNumber;
    _jsonData = jsonData;
    _binaryData = binaryData;

    return self;
}

+ (nullable id)securityPayloadWithData:(NSData *)data {
    return [[SDLSecurityQueryPayload alloc] initWithData:data];
}

- (NSData *)convertToData {
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
    NSUInteger jsonDataSize = self.jsonData.length;
    NSUInteger binaryDataSize = self.binaryData.length;
    NSUInteger size = SECURITY_QUERY_HEADER_SIZE + jsonDataSize + binaryDataSize;
    NSMutableData *dataOut = [NSMutableData dataWithCapacity:size];
    [dataOut appendBytes:&headerBuffer length:12];
    [dataOut appendData:self.jsonData];
    [dataOut appendData:self.binaryData];

    return dataOut;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Security Query Header: %@, %@, sequenceNumber: %lu, json size: %lu bytes, binary size: %lu bytes", [self descriptionForQueryID], [self descriptionForQueryType], (unsigned long)self.sequenceNumber, (unsigned long)self.jsonData.length, (unsigned long)self.binaryData.length];
}

- (NSString *)descriptionForQueryID {
    NSString *queryIdDescription;
    switch (self.queryID) {
        case SDLSecurityQueryIdSendHandshake:
            queryIdDescription = @"Send Handshake Data";
            break;
        case SDLSecurityQueryIdSendInternalError:
            queryIdDescription = @"Send Internal Error";
            break;
        case SDLSecurityQueryIdInvalid:
            queryIdDescription = @"Invalid Query ID";
            break;
        default:
            queryIdDescription = @"Unknown Query ID";
            break;
    }
    return [NSString stringWithFormat:@"queryID: %lu - %@", (unsigned long)self.queryID, queryIdDescription];
}

- (NSString *)descriptionForQueryType {
    NSString *queryTypeDescription;
    switch (self.queryType) {
        case SDLSecurityQueryTypeRequest:
            queryTypeDescription = @"Request";
            break;
        case SDLSecurityQueryTypeResponse:
            queryTypeDescription = @"Response";
            break;
        case SDLSecurityQueryTypeNotification:
            queryTypeDescription = @"Notification";
            break;
        case SDLSecurityQueryTypeInvalid:
            queryTypeDescription = @"Invalid Query Type";
            break;
        default:
            queryTypeDescription = @"Unknown Query Type";
            break;
    }
    return [NSString stringWithFormat:@"queryType: %lu - %@", (unsigned long)self.queryType, queryTypeDescription];
}

@end

NS_ASSUME_NONNULL_END
