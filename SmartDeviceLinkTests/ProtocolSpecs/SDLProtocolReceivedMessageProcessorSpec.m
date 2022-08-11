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



@interface SDLProtocolReceivedMessageProcessor(){}
// State management
@property (assign, nonatomic) NSUInteger state; //todo - I changed type to avoid issues with the enum

// Message assembly state
@property (strong, nonatomic) SDLProtocolHeader *header;
@property (strong, nonatomic) NSMutableData *headerBuffer;
@property (strong, nonatomic) NSMutableData *payloadBuffer;

// Error checking
@property (assign, nonatomic) UInt8 version;
@property (assign, nonatomic) BOOL encrypted;
@property (assign, nonatomic) SDLFrameType frameType;
@property (assign, nonatomic) UInt32 dataLength;
@property (assign, nonatomic) UInt32 dataBytesRemaining;
@end

QuickSpecBegin(SDLProtocolReceivedMessageProcessorSpec)

describe(@"The recieved message processor", ^{
    __block SDLProtocolReceivedMessageProcessor *testProcessor = nil;
    __block NSMutableData *testBuffer;
    
    beforeEach(^{
        testProcessor = [[SDLProtocolReceivedMessageProcessor alloc] init];
        testBuffer = [NSMutableData data];
    });
    

    context(@"When it recieves a byte while in the START_STATE", ^{
        it(@"transitions to SERVICE_TYPE_STATE if the byte is valid", ^{
            testProcessor.state = 0x00;
            //Byte testByte = 17;
            Byte testByte = 0x11;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                //do nothing?
            }];
            expect(testProcessor.state).to(equal(0x01));
        });
        it(@"transitions to ERROR_STATE if the byte is notvalid", ^{
            testProcessor.state = 0x00;
            //Byte testByte = 17;
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                //do nothing?
            }];
            expect(testProcessor.state).to(equal(-1));  //TODO - this doesn't work right
        });
    });
    context(@"When it recieves a valid byte while in the SERVICE_TYPE_STATE", ^{
        it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
            testProcessor.state = 0x01;
            Byte testByte = 0x0b;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                //do nothing?
            }];
            expect(testProcessor.state).to(equal(0x02));
        });
    });
});


describe(@"FAIL State Machine START_STATE", ^{
    
    __block SDLProtocolReceivedMessageProcessor *testReceiveProcessor;
    __block SDLProtocolMessage *testMessage;
    __block SDLProtocolHeader *testHeader;
    __block NSMutableData *testPayloadBuffer;
    __block NSMutableData *testHeaderBuffer;
    
    beforeEach(^{
        testReceiveProcessor = [[SDLProtocolReceivedMessageProcessor alloc] init];
    });
    
    it(@"can pass a good message version 1, frame type ", ^{
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
