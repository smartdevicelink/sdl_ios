//  SDLProtocolMessageDisassembler.m
//

#import "SDLProtocolMessageDisassembler.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLProtocolMessageDisassembler

+ (NSArray<SDLProtocolMessage *> *)disassemble:(SDLProtocolMessage *)protocolMessage withMTULimit:(NSUInteger)mtu {
    if (protocolMessage.size < mtu) {
        return @[protocolMessage];
    }

    // How big is the message header and payload?
    NSUInteger headerSize = protocolMessage.header.size;
    NSUInteger payloadSize = (protocolMessage.data.length - headerSize);

    // How many messages do we need to create to hold that many bytes?
    // Note: This does NOT count the special first message which acts as a descriptor.
    NSUInteger numberOfMessagesRequired = (NSUInteger)ceilf((float)payloadSize / (float)(mtu - headerSize));

    // And how many data bytes go in each message?
    NSUInteger numberOfDataBytesPerMessage = mtu - headerSize;

    // Create the outgoing array to hold the messages we will create.
    NSMutableArray<SDLProtocolMessage *> *outgoingMessages = [NSMutableArray arrayWithCapacity:numberOfMessagesRequired + 1];

    // Create the first message, which cannot be encrypted because it needs to be exactly 8 bytes
    SDLProtocolHeader *firstFrameHeader = [protocolMessage.header copy];
    firstFrameHeader.frameType = SDLFrameTypeFirst;
    firstFrameHeader.encrypted = NO;

    UInt32 payloadData[2];
    payloadData[0] = CFSwapInt32HostToBig((UInt32)protocolMessage.payload.length);
    payloadData[1] = CFSwapInt32HostToBig((UInt32)numberOfMessagesRequired);
    NSMutableData *firstFramePayload = [NSMutableData dataWithBytes:payloadData length:sizeof(payloadData)];

    SDLProtocolMessage *firstMessage = [SDLProtocolMessage messageWithHeader:firstFrameHeader andPayload:firstFramePayload];
    [outgoingMessages addObject:firstMessage];

    // Create the middle messages (the ones carrying the actual data).
    for (NSUInteger n = 0; n < numberOfMessagesRequired - 1; n++) {
        // Frame # after 255 must cycle back to 1, not 0. A 0 signals last frame (SDLFrameInfoConsecutiveLastFrame).
        UInt8 frameNumber = (n % 255) + 1;

        SDLProtocolHeader *nextFrameHeader = [protocolMessage.header copy];
        nextFrameHeader.frameType = SDLFrameTypeConsecutive;
        nextFrameHeader.frameData = frameNumber;

        NSUInteger offsetOfDataForThisFrame = headerSize + (n * numberOfDataBytesPerMessage);
        NSData *nextFramePayload = [protocolMessage.data subdataWithRange:NSMakeRange(offsetOfDataForThisFrame, numberOfDataBytesPerMessage)];

        SDLProtocolMessage *nextMessage = [SDLProtocolMessage messageWithHeader:nextFrameHeader andPayload:nextFramePayload];
        outgoingMessages[n + 1] = nextMessage;
    }

    // Create the last message
    SDLProtocolHeader *lastFrameHeader = [protocolMessage.header copy];
    lastFrameHeader.frameType = SDLFrameTypeConsecutive;
    lastFrameHeader.frameData = SDLFrameInfoConsecutiveLastFrame;

    NSUInteger numberOfMessagesCreatedSoFar = numberOfMessagesRequired - 1;
    NSUInteger numberOfDataBytesSentSoFar = numberOfMessagesCreatedSoFar * numberOfDataBytesPerMessage;
    NSUInteger numberOfDataBytesInLastMessage = payloadSize - numberOfDataBytesSentSoFar;
    NSUInteger offsetOfDataForLastFrame = headerSize + numberOfDataBytesSentSoFar;
    NSData *lastFramePayload = [protocolMessage.data subdataWithRange:NSMakeRange(offsetOfDataForLastFrame, numberOfDataBytesInLastMessage)];

    SDLProtocolMessage *lastMessage = [SDLProtocolMessage messageWithHeader:lastFrameHeader andPayload:lastFramePayload];
    outgoingMessages[numberOfMessagesRequired] = lastMessage;

    return outgoingMessages;
}

@end

NS_ASSUME_NONNULL_END
