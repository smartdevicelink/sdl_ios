//
//  SDLProtocolMessageDisassemblerSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLGlobals.h"
#import "SDLProtocolMessageDisassembler.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLRPCParameterNames.h"
#import "SDLVersion.h"

QuickSpecBegin(SDLProtocolMessageDisassemblerSpec)

describe(@"SDLProtocolMessageDisassembler Tests", ^ {
    context(@"when the MTU size is larger than the payload size", ^{
        it(@"should disassemble the message properly", ^{
            const NSUInteger dataLength = 400;
            char dummyBytes[dataLength];

            const char testPayloadHeader[12] = {0x20, 0x55, 0x64, 0x73, 0x12, 0x34, 0x43, 0x21, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};

            NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
            [payloadData appendBytes:dummyBytes length:dataLength];

            SDLV2ProtocolMessage *testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] init];

            testHeader.frameType = SDLFrameTypeSingle;
            testHeader.serviceType = SDLServiceTypeBulkData;
            testHeader.frameData = SDLFrameInfoSingleFrame;
            testHeader.sessionID = 0x84;
            testHeader.bytesInPayload = (UInt32)payloadData.length;

            testMessage.header = testHeader;
            testMessage.payload = payloadData;

            NSArray<SDLProtocolMessage *> *messageList = [SDLProtocolMessageDisassembler disassemble:testMessage withMTULimit:1024];
            expect(messageList.count).to(equal(1));
            expect(messageList[0]).to(equal(testMessage));
        });
    });

    context(@"when the MTU size is smaller than the payload size", ^{
        it(@"Should disassemble the message properly", ^ {
            //Allocate 4000 bytes and use it as sample data
            const NSUInteger dataLength = 4000;
            char dummyBytes[dataLength];

            const char testPayloadHeader[12] = {0x20, 0x55, 0x64, 0x73, 0x12, 0x34, 0x43, 0x21, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};

            NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
            [payloadData appendBytes:dummyBytes length:dataLength];

            SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];

            testHeader.frameType = SDLFrameTypeSingle;
            testHeader.serviceType = SDLServiceTypeBulkData;
            testHeader.frameData = SDLFrameInfoSingleFrame;
            testHeader.sessionID = 0x84;
            testHeader.bytesInPayload = (UInt32)payloadData.length;

            testMessage.header = testHeader;
            testMessage.payload = payloadData;

            NSArray<SDLProtocolMessage *> *messageList = [SDLProtocolMessageDisassembler disassemble:testMessage withMTULimit:1024];
            expect(messageList.count).to(equal(5));

            //Payload length per message
            UInt32 payloadLength = 1012; // v1/2 MTU(1024) - header length(12)

            const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(1.0 * payloadData.length / payloadLength)};

            SDLProtocolMessage* message = messageList[0];

            //First frame
            expect(message.payload).to(equal([NSData dataWithBytes:firstPayload length:8]));

            expect(@(message.header.frameType)).to(equal(@(SDLFrameTypeFirst)));
            expect(@(message.header.serviceType)).to(equal(@(SDLServiceTypeBulkData)));
            expect(@(message.header.frameData)).to(equal(@(SDLFrameInfoFirstFrame)));
            expect(@(message.header.sessionID)).to(equal(@0x84));
            expect(@(message.header.bytesInPayload)).to(equal(@8));

            NSUInteger offset = 0;
            for (int i = 1; i < messageList.count - 1; i++) {
                message = messageList[i];

                //Consecutive frames
                expect(message.payload).to(equal([NSData dataWithData:[payloadData subdataWithRange:NSMakeRange(offset, payloadLength)]]));

                expect(@(message.header.frameType)).to(equal(@(SDLFrameTypeConsecutive)));
                expect(@(message.header.serviceType)).to(equal(@(SDLServiceTypeBulkData)));
                expect(@(message.header.frameData)).to(equal(@(i)));
                expect(@(message.header.sessionID)).to(equal(@0x84));
                expect(@(message.header.bytesInPayload)).to(equal(@(payloadLength)));

                offset += payloadLength;
            }

            message = [messageList lastObject];

            NSUInteger remaining = payloadData.length - offset;

            //Last frame
            expect(message.payload).to(equal([NSData dataWithData:[payloadData subdataWithRange:NSMakeRange(offset, remaining)]]));

            expect(@(message.header.frameType)).to(equal(@(SDLFrameTypeConsecutive)));
            expect(@(message.header.serviceType)).to(equal(@(SDLServiceTypeBulkData)));
            expect(@(message.header.frameData)).to(equal(@(SDLFrameInfoConsecutiveLastFrame)));
            expect(@(message.header.sessionID)).to(equal(@0x84));
            expect(@(message.header.bytesInPayload)).to(equal(@(remaining)));
        });
    });
});

QuickSpecEnd
