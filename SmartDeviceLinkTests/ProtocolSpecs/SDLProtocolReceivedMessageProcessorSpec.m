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

typedef NS_ENUM(NSInteger, ProcessorState) {
    START_STATE = 0x0,
    SERVICE_TYPE_STATE = 0x01,
    CONTROL_FRAME_INFO_STATE = 0x02,
    SESSION_ID_STATE = 0x03,
    DATA_SIZE_1_STATE = 0x04,
    DATA_SIZE_2_STATE = 0x05,
    DATA_SIZE_3_STATE = 0x06,
    DATA_SIZE_4_STATE = 0x07,
    MESSAGE_1_STATE = 0x08,
    MESSAGE_2_STATE = 0x09,
    MESSAGE_3_STATE = 0x0A,
    MESSAGE_4_STATE = 0x0B,
    DATA_PUMP_STATE = 0x0C,
    ERROR_STATE = -1,
};

@interface SDLProtocolReceivedMessageProcessor(){}
// State management
@property (assign, nonatomic) ProcessorState state;

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

describe(@"The processor", ^{
    __block SDLProtocolReceivedMessageProcessor *testProcessor = nil;
    __block NSMutableData *testBuffer;
    
    beforeEach(^{
        testProcessor = [[SDLProtocolReceivedMessageProcessor alloc] init];
        testBuffer = [NSMutableData data];
    });
    context(@"in START_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to SERVICE_TYPE_STATE if the byte is valid", ^{
                testProcessor.state = START_STATE;
                Byte testByte = 0x11;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
            });
            it(@"transitions to ERROR_STATE if the byte is notvalid", ^{
                testProcessor.state = START_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(ERROR_STATE));  //TODO - this doesn't work right
            });
        });
    });
    context(@"in SERVICE_TYPE_STATE", ^{
        context(@"When it recieves a byte", ^{
            it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
                testProcessor.state = SERVICE_TYPE_STATE;
                Byte testByte = 0x0b;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
            });
        });
    });
    context(@"in CONTROL_FRAME_INFO_STATE", ^{
        context(@"recieves a SDLServiceTypeControl byte", ^{
            it(@"transitions to SESSION_ID_STATE", ^{
                testProcessor.state = CONTROL_FRAME_INFO_STATE;
                Byte testByte = SDLServiceTypeControl;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
            });
        });
        context(@"recieves a SDLServiceTypeRPC byte", ^{
            it(@"transitions to SESSION_ID_STATE", ^{
                testProcessor.state = CONTROL_FRAME_INFO_STATE;
                Byte testByte = SDLServiceTypeRPC;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
            });
        });
        context(@"recieves a SDLServiceTypeAudio byte", ^{
            it(@"transitions to SESSION_ID_STATE", ^{
                testProcessor.state = CONTROL_FRAME_INFO_STATE;
                Byte testByte = SDLServiceTypeAudio;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
            });
        });
        context(@"recieves a SDLServiceTypeVideo byte", ^{
            it(@"transitions to SESSION_ID_STATE", ^{
                testProcessor.state = CONTROL_FRAME_INFO_STATE;
                Byte testByte = SDLServiceTypeVideo;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
            });
        });
        context(@"recieves a SDLServiceTypeBulkData byte", ^{
            it(@"transitions to SESSION_ID_STATE", ^{
                testProcessor.state = CONTROL_FRAME_INFO_STATE;
                Byte testByte = SDLServiceTypeBulkData;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
            });
        });
    });
    context(@"in SESSION_ID_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to DATA_SIZE_1_STATE", ^{
                testProcessor.state = SESSION_ID_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(DATA_SIZE_1_STATE));
            });
        });
    });
    context(@"in DATA_SIZE_1_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to DATA_SIZE_2_STATE", ^{
                testProcessor.state = DATA_SIZE_1_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(DATA_SIZE_2_STATE));
            });
        });
    });
    context(@"in DATA_SIZE_2_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to DATA_SIZE_3_STATE", ^{
                testProcessor.state = DATA_SIZE_2_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(DATA_SIZE_3_STATE));
            });
        });
    });
    context(@"in DATA_SIZE_3_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to DATA_SIZE_4_STATE", ^{
                testProcessor.state = DATA_SIZE_3_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(DATA_SIZE_4_STATE));
            });
        });
    });
    context(@"in DATA_SIZE_4_STATE", ^{
        context(@"if version is 1", ^{
            context(@"datalength is 0", ^{
                context(@"recieves a byte", ^{
                    it(@"transitions to START_STATE", ^{
                        testProcessor.state = DATA_SIZE_4_STATE;
                        testProcessor.version = 1;
                        testProcessor.dataLength = 0;
                        Byte testByte = 0x00;
                        [testBuffer appendBytes:&testByte length:1];
                        
                        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                            //do nothing?
                        }];
                        expect(@(testProcessor.state)).to(equal(START_STATE));
                    });
                });
            });
            context(@"datalength is greater than 0", ^{
                context(@"recieves a byte", ^{
                    it(@"transitions to DATA_PUMP_STATE", ^{
                        testProcessor.state = DATA_SIZE_4_STATE;
                        testProcessor.version = 1;
                        testProcessor.dataLength = 1;
                        Byte testByte = 0x00;
                        [testBuffer appendBytes:&testByte length:1];
                        
                        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                            //do nothing?
                        }];
                        expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                    });
                });
            });
        });
        context(@"if version greater than 1", ^{
            context(@"recieves a byte", ^{
                it(@"transitions to MESSAGE_1_STATE", ^{
                    testProcessor.state = DATA_SIZE_4_STATE;
                    testProcessor.version = 2;
                    testProcessor.dataLength = 0;
                    Byte testByte = 0x00;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(MESSAGE_1_STATE));
                });
            });
    
        });
    });
    context(@"in MESSAGE_1_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to MESSAGE_2_STATE", ^{
                testProcessor.state = MESSAGE_1_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(MESSAGE_2_STATE));
            });
        });
    });
    context(@"in MESSAGE_2_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to MESSAGE_3_STATE", ^{
                testProcessor.state = MESSAGE_2_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(MESSAGE_3_STATE));
            });
        });
    });
    context(@"in MESSAGE_3_STATE", ^{
        context(@"recieves a byte", ^{
            it(@"transitions to MESSAGE_4_STATE", ^{
                testProcessor.state = MESSAGE_3_STATE;
                Byte testByte = 0x00;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(MESSAGE_4_STATE));
            });
        });
    });
    context(@"in MESSAGE_4_STATE", ^{
        context(@"datalength is 0", ^{
            context(@"recieves a byte", ^{
                it(@"transitions to START_STATE", ^{
                    testProcessor.state = MESSAGE_4_STATE;
                    testProcessor.dataLength = 0;
                    Byte testByte = 0x00;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(START_STATE));
                });
            });
            context(@"datalength is greater than 0", ^{
                context(@"recieves a byte", ^{
                    it(@"transitions to DATA_PUMP_STATE", ^{
                        testProcessor.state = MESSAGE_4_STATE;
                        testProcessor.dataLength = 1;
                        Byte testByte = 0x00;
                        [testBuffer appendBytes:&testByte length:1];
                        
                        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                            //do nothing?
                        }];
                        expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                    });
                });
            });
        });
    });
});
    

QuickSpecEnd
