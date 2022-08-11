//
//  SDLProtocolReceivedMessageProcessorSpec.m
//  SmartDeviceLinkTests
//
//  Created by George Miller on 8/9/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLProtocol.h"
#import "SDLProtocolReceivedMessageProcessor.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"


QuickSpecBegin(SDLProtocolReceivedMessageProcessorSpec)

describe(@"State Machine START_STATE", ^{
    
    __block SDLProtocolReceivedMessageProcessor *testReceiveProcessor;
    __block SDLProtocolMessage *testMessage;
    __block SDLProtocolHeader *testHeader;
    __block NSMutableData *testPayloadBuffer;
    __block NSMutableData *testHeaderBuffer;
    
    beforeEach(^{
        testReceiveProcessor = [[SDLProtocolReceivedMessageProcessor alloc] init];
    });
    
    it(@"can pass a good message", ^{
        // setup the test
        UInt8 version = 1;
        BOOL encrypted = 0;
        UInt8 frameType = 0;
        UInt32 datasize = 0;
        Byte firstByte = ((version & 0x0f) << 4) + (encrypted << 3) + (frameType & 0x07);
        const Byte testBytes[8] = {firstByte, 0x00, 0x00, 0x00, (datasize >> 24) & 0xff, (datasize >> 16) & 0xff, (datasize >> 8) & 0xff, (datasize) & 0xff };
        [testHeaderBuffer appendBytes:&testBytes length:8];
        UInt32 messageID = 0;
        Byte messageIDBytes[4] = {(messageID >> 24) & 0xff, (messageID >> 16) & 0xff, (messageID >> 8) & 0xff, (messageID) & 0xff};
        [testHeaderBuffer appendBytes:&messageIDBytes length:4];
        Byte testPayloadByte;
        for(int i=0;i<datasize;i++){
            testPayloadByte = 0xba;
            [testPayloadBuffer appendBytes:&testPayloadByte length:1];
        }
        
        if (testHeaderBuffer != nil){
            testHeader = [SDLProtocolHeader headerForVersion:version];
            [testHeader parse:testHeaderBuffer];
            testMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testPayloadBuffer];
        }

        // run test
        [testReceiveProcessor processReceiveBuffer:testMessage.data withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            expect(header).to(equal(testHeader));
            expect(payload).to(equal(testPayloadBuffer));
        }];
        //TODO - how will tests end for cases where it doesn't call the block?
    });
    
    
});

QuickSpecEnd
