//
//  PolicyDataParser.m
//

#import "SDLPolicyDataParser.h"
#import "SDLDebugTool.h"

@implementation SDLPolicyDataParser

- (NSData *)unwrap:(NSData *)wrappedData {
    NSData *decodedData = nil;

    @try {
        NSError *errorJSONSerialization = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:wrappedData options:kNilOptions error:&errorJSONSerialization];
        NSArray *array = dictionary[@"data"];
        NSString *base64EncodedString = array[0];

        if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
            decodedData = [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:0];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            decodedData = [[NSData alloc] initWithBase64Encoding:base64EncodedString];
#pragma clang diagnostic pop
        }
    }
    @catch (NSException *exception) {
        decodedData = nil;
        [SDLDebugTool logInfo:@"Error in PolicyDataParser::unwrap()"];
    }

    return decodedData;
}

- (void)parsePolicyData:(NSData *)data {
    if (data == nil) {
        return;
    }

    @try {
        Byte *bytes = (Byte *)data.bytes;

        Byte firstByte = bytes[0];
        self.protocolVersion = (firstByte & 0b11100000) >> 5;
        self.isResponseRequired = (firstByte & 0b00010000) != 0;
        self.isHighBandwidth = (firstByte & 0b00001000) != 0;
        self.isSigned = (firstByte & 0b00000100) != 0;
        self.isEncrypted = (firstByte & 0b00000010) != 0;
        self.hasESN = (firstByte & 0b00000001) != 0;

        self.serviceType = bytes[1];

        Byte thirdByte = bytes[2];
        self.commandType = (thirdByte & 0b11110000) >> 4;
        self.CPUDestination = (thirdByte & 0b00001000) != 0;
        self.encryptionKeyIndex = (thirdByte & 0b00000111);

        const int payloadSizeOffset = 3;
        if (self.isHighBandwidth) {
            self.payloadSize = ntohl(*(UInt32 *)(bytes + payloadSizeOffset));
        } else {
            self.payloadSize = ntohs(*(UInt16 *)(bytes + payloadSizeOffset));
        }

        if (self.hasESN) {
            int esnOffset = self.isHighBandwidth ? 7 : 5;
            self.ESN = [NSData dataWithBytes:(bytes + esnOffset) length:8];
        }

        if (self.isHighBandwidth) {
            int moduleMessageIdOffset = 7;
            if (self.hasESN)
                moduleMessageIdOffset += self.ESN.length;
            self.moduleMessageId = ntohl(*(UInt32 *)(bytes + moduleMessageIdOffset));

            int serverMessageIdOffset = 11;
            if (self.hasESN)
                serverMessageIdOffset += self.ESN.length;
            self.serverMessageId = ntohl(*(UInt32 *)(bytes + serverMessageIdOffset));

            int messageStatusOffset = 15;
            if (self.hasESN)
                messageStatusOffset += self.ESN.length;
            self.messageStatus = bytes[messageStatusOffset];
        }

        if (self.isEncrypted) {
            int ivOffset = 5;
            if (self.isHighBandwidth)
                ivOffset += 11;
            if (self.hasESN)
                ivOffset += self.ESN.length;
            self.initializationVector = [NSData dataWithBytes:(bytes + ivOffset) length:16];
        }

        int payloadOffset = 5;
        if (self.isHighBandwidth)
            payloadOffset += 11;
        if (self.hasESN)
            payloadOffset += self.ESN.length;
        if (self.isEncrypted)
            payloadOffset += self.initializationVector.length;
        self.payload = [NSData dataWithBytes:(bytes + payloadOffset) length:self.payloadSize];

        if (self.isSigned) {
            int signatureTagOffset = (int)data.length - 16;
            self.signatureTag = [NSData dataWithBytes:(bytes + signatureTagOffset) length:16];
        }

    }
    @catch (NSException *exception) {
        [SDLDebugTool logInfo:@"Error in PolicyDataParser::parsePolicyData()"];
    }
}

- (NSString *)description {
    NSString *esnString = [[NSString alloc] initWithData:self.ESN encoding:NSUTF8StringEncoding];

    NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"Ver:%u; ", self.protocolVersion];
    [descriptionString appendFormat:@"RespReq:%u; ", self.isResponseRequired];
    [descriptionString appendFormat:@"HiBnd:%u; ", self.isHighBandwidth];
    [descriptionString appendFormat:@"Sign:%u; ", self.isSigned];
    [descriptionString appendFormat:@"Enc:%u; ", self.isEncrypted];
    [descriptionString appendFormat:@"HasESN:%u; ", self.hasESN];
    [descriptionString appendFormat:@"Svc:%u; ", self.serviceType];
    [descriptionString appendFormat:@"Cmd:%u; ", self.commandType];
    [descriptionString appendFormat:@"CPU:%u; ", self.CPUDestination];
    [descriptionString appendFormat:@"EncKey:%u; ", self.encryptionKeyIndex];
    [descriptionString appendFormat:@"sz:%u; ", (unsigned int)self.payloadSize];
    [descriptionString appendFormat:@"ESN:%@; ", esnString];
    [descriptionString appendFormat:@"mmid:%u; ", (unsigned int)self.moduleMessageId];
    [descriptionString appendFormat:@"smid:%u; ", (unsigned int)self.serverMessageId];
    [descriptionString appendFormat:@"status:%u; ", self.messageStatus];
    [descriptionString appendFormat:@"iv:%@; ", self.initializationVector];
    [descriptionString appendFormat:@"hmac:%@", self.signatureTag];
    return descriptionString;
}

@end
