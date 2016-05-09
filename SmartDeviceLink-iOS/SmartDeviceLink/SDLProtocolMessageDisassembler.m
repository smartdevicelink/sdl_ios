//  SDLProtocolMessageDisassembler.m
//

#import "SDLProtocolMessageDisassembler.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"


@implementation SDLProtocolMessageDisassembler


// Use to break up a large message into a sequence of smaller messages,
// each of which is less than 'mtu' number of bytes total size.
+ (NSArray *)disassemble:(SDLProtocolMessage *)incomingMessage withLimit:(NSUInteger)mtu {
    // Questions:
    // What message IDs does the current system use? Same messageIDs? Same CorrelationIDs?
    // What gets simply copied from incoming header to created headers; and what needs adjustment?

    // How big is the message header?
    NSUInteger headerSize = incomingMessage.header.size;

    // The size of the message is too big to send in one chunk.
    // So lets break it up.
    // Just how big IS this message?
    NSUInteger incomingPayloadSize = (incomingMessage.data.length - headerSize);

    // How many messages do we need to create to hold that many bytes?
    // Note: this does NOT count the special first message which acts as a descriptor.
    NSUInteger numberOfMessagesRequired = ceil((float)incomingPayloadSize / (float)(mtu - headerSize));

    // And how many data bytes go in each message?
    NSUInteger numberOfDataBytesPerMessage = mtu - headerSize;

    // Create the outgoing array to hold the messages we will create.
    NSMutableArray *outgoingMessages = [NSMutableArray arrayWithCapacity:numberOfMessagesRequired + 1];


    // Create the first message
    SDLProtocolHeader *firstFrameHeader = [incomingMessage.header copy];
    firstFrameHeader.frameType = SDLFrameType_First;

    UInt32 payloadData[2];
    payloadData[0] = CFSwapInt32HostToBig((UInt32)incomingMessage.payload.length);
    payloadData[1] = CFSwapInt32HostToBig((UInt32)numberOfMessagesRequired);
    NSMutableData *firstFramePayload = [NSMutableData dataWithBytes:payloadData length:sizeof(payloadData)];
    firstFrameHeader.bytesInPayload = (UInt32)firstFramePayload.length;

    SDLProtocolMessage *firstMessage = [SDLProtocolMessage messageWithHeader:firstFrameHeader andPayload:firstFramePayload];
    outgoingMessages[0] = firstMessage;


    // Create the middle messages (the ones carrying the actual data).
    for (int n = 0; n < numberOfMessagesRequired - 1; n++) {
        // Frame # after 255 must cycle back to 1, not 0.
        // A 0 signals last frame.
        UInt8 frameNumber = (n % 255) + 1;

        SDLProtocolHeader *nextFrameHeader = [incomingMessage.header copy];
        nextFrameHeader.frameType = SDLFrameType_Consecutive;
        nextFrameHeader.frameData = frameNumber;

        NSUInteger offsetOfDataForThisFrame = headerSize + (n * numberOfDataBytesPerMessage);
        NSData *nextFramePayload = [incomingMessage.data subdataWithRange:NSMakeRange(offsetOfDataForThisFrame, numberOfDataBytesPerMessage)];
        nextFrameHeader.bytesInPayload = (UInt32)nextFramePayload.length;

        SDLProtocolMessage *nextMessage = [SDLProtocolMessage messageWithHeader:nextFrameHeader andPayload:nextFramePayload];
        outgoingMessages[n + 1] = nextMessage;
    }


    // Create the last message
    SDLProtocolHeader *lastFrameHeader = [incomingMessage.header copy];
    lastFrameHeader.frameType = SDLFrameType_Consecutive;
    lastFrameHeader.frameData = SDLFrameData_ConsecutiveLastFrame;

    NSUInteger numberOfMessagesCreatedSoFar = numberOfMessagesRequired - 1;
    NSUInteger numberOfDataBytesSentSoFar = numberOfMessagesCreatedSoFar * numberOfDataBytesPerMessage;
    NSUInteger numberOfDataBytesInLastMessage = incomingPayloadSize - numberOfDataBytesSentSoFar;
    NSUInteger offsetOfDataForLastFrame = headerSize + numberOfDataBytesSentSoFar;
    NSData *lastFramePayload = [incomingMessage.data subdataWithRange:NSMakeRange(offsetOfDataForLastFrame, numberOfDataBytesInLastMessage)];
    lastFrameHeader.bytesInPayload = (UInt32)lastFramePayload.length;

    SDLProtocolMessage *lastMessage = [SDLProtocolMessage messageWithHeader:lastFrameHeader andPayload:lastFramePayload];
    outgoingMessages[numberOfMessagesRequired] = lastMessage;

    return outgoingMessages;
}

@end
