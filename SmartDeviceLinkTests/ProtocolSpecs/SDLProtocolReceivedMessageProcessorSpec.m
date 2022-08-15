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
@property (assign, nonatomic) SDLServiceType serviceType;
@end

QuickSpecBegin(SDLProtocolReceivedMessageProcessorSpec)

describe(@"The processor", ^{
    __block SDLProtocolReceivedMessageProcessor *testProcessor = nil;
    __block NSMutableData *testBuffer;
    __block NSMutableData *testHeaderBuffer;
    
    beforeEach(^{
        testProcessor = [[SDLProtocolReceivedMessageProcessor alloc] init];
        testBuffer = [NSMutableData data];
        testHeaderBuffer = [NSMutableData data];
    });
    context(@"in START_STATE", ^{
        beforeEach(^{
            testProcessor.state = START_STATE;
        });
        context(@"When it recieves a byte", ^{
            context(@"with a good version 1", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x11;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a good version 2", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x21;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a good version 3", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x31;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a good version 4", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x41;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a good version 5", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x51;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a bad version 0", ^{
                it(@"resets state to START_STATE if the byte is not valid", ^{
                    Byte testByte = 0x01;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(START_STATE));
                });
            });
            context(@"with a bad version 6", ^{
                it(@"resets state to START_STATE if the byte is not valid", ^{
                    Byte testByte = 0x61;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(START_STATE));
                });
            });
            context(@"with a frameType of SDLFrameTypeControl", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x10;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a frameType of SDLFrameTypeSingle", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x11;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a frameType of SDLFrameTypeFirst", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x12;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with a frameType of SDLFrameTypeConsecutive", ^{
                it(@"transitions to SERVICE_TYPE_STATE", ^{
                    Byte testByte = 0x13;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                });
            });
            context(@"with an invalid frameType of 6", ^{
                it(@"resets state to START_STATE", ^{
                    Byte testByte = 0x66;
                    [testBuffer appendBytes:&testByte length:1];
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(START_STATE));
                });
            });
        });
    });
    context(@"in SERVICE_TYPE_STATE", ^{
        beforeEach(^{
            testProcessor.state = SERVICE_TYPE_STATE;
        });
        context(@"When it recieves a SDLServiceTypeControl byte", ^{
            it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
                Byte testByte = SDLServiceTypeControl;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
            });
        });
        context(@"When it recieves a SDLServiceTypeRPC byte", ^{
            it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
                Byte testByte = SDLServiceTypeRPC;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
            });
        });
        context(@"When it recieves a SDLServiceTypeAudio byte", ^{
            it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
                Byte testByte = SDLServiceTypeAudio;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
            });
        });
        context(@"When it recieves a SDLServiceTypeVideo byte", ^{
            it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
                Byte testByte = SDLServiceTypeVideo;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
            });
        });
        context(@"When it recieves a SDLServiceTypeBulkData byte", ^{
            it(@"transitions to CONTROL_FRAME_INFO_STATE", ^{
                Byte testByte = SDLServiceTypeBulkData;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
            });
        });
        context(@"recieves an invalid byte", ^{
            it(@"resets state to START_STATE", ^{
                Byte testByte = 0xFF;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(START_STATE));
            });
        });
    });
    context(@"in CONTROL_FRAME_INFO_STATE", ^{
        beforeEach(^{
            testProcessor.state = CONTROL_FRAME_INFO_STATE;
        });
        context(@"recieves a valid byte", ^{
            it(@"transitions to SESSION_ID_STATE", ^{
                Byte testByte = 0x00;
                testProcessor.frameType = SDLFrameTypeFirst;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
            });
        });
        context(@"controlFrameInfo is not 0 for a SDLFrameTypeFirst", ^{
            it(@"resets to START_STATE", ^{
                Byte testByte = 0x01;
                testProcessor.frameType = SDLFrameTypeFirst;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(START_STATE));
            });
        });
        context(@"controlFrameInfo is not 0 for a SDLFrameTypeSingle", ^{
            it(@"resets to START_STATE", ^{
                Byte testByte = 0x01;
                testProcessor.frameType = SDLFrameTypeSingle;
                [testBuffer appendBytes:&testByte length:1];
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(START_STATE));
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
        beforeEach(^{
            testProcessor.state = DATA_SIZE_4_STATE;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
        });
        context(@"if version is 1", ^{
            beforeEach(^{
                testProcessor.version = 1;
            });
            context(@"datalength is 0", ^{
                context(@"recieves a byte", ^{
                    it(@"resets state to START_STATE", ^{
                        testProcessor.dataLength = 0;
                        
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
                        testProcessor.dataLength = 1;
                        
                        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                            //do nothing?
                        }];
                        expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                    });
                });
            });
            context(@"datalength is greater than maxMtuSize", ^{
                context(@"recieves a byte", ^{
                    it(@"transitions to DATA_PUMP_STATE", ^{
                        testProcessor.serviceType = SDLServiceTypeControl;
                        testProcessor.dataLength = 200000;
                        
                        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                            //do nothing?
                        }];
                        expect(@(testProcessor.state)).to(equal(START_STATE));
                    });
                });
            });
            
        });
        context(@"if version greater than 1", ^{
            context(@"recieves a byte", ^{
                it(@"transitions to MESSAGE_1_STATE", ^{
                    testProcessor.version = 2;
                    testProcessor.dataLength = 0;
                    
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
        beforeEach(^{
            testProcessor.state = MESSAGE_4_STATE;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
        });
        context(@"datalength is 0", ^{
            context(@"recieves a byte", ^{
                it(@"resets state to START_STATE", ^{
                    testProcessor.dataLength = 0;
                    
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
                    testProcessor.dataLength = 1;
                    
                    [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                        //do nothing?
                    }];
                    expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                });
            });
        });
    });
    context(@"in DATA_PUMP_STATE", ^{
        beforeEach(^{
            testProcessor.state = DATA_PUMP_STATE;
            testProcessor.version = 5;
            //need a valid headerbuffer.  TODO - Lots of magic numbers here.
            Byte firstByte = ((5 & 0x0f) << 4) + (0 << 3) + (1 & 0x07); //version 5 with no encryption, frametype 1
            const Byte testBytes[8] = {firstByte, 0x00, 0x00, 0x00, (3 >> 24) & 0xff, (3 >> 16) & 0xff, (3 >> 8) & 0xff, (3) & 0xff };
            [testHeaderBuffer appendBytes:&testBytes length:8];
            UInt32 messageID = 0;
            Byte messageIDBytes[4] = {(messageID >> 24) & 0xff, (messageID >> 16) & 0xff, (messageID >> 8) & 0xff, (messageID) & 0xff};
            [testHeaderBuffer appendBytes:&messageIDBytes length:4];
            
            testProcessor.headerBuffer = testHeaderBuffer;
            
            Byte testByte = 0xBA;
            [testBuffer appendBytes:&testByte length:1];
        });
        context(@"dataBytesRemaining is greater than 1", ^{
            it(@"Stays in DATA_PUMP_STATE", ^{
                testProcessor.dataBytesRemaining = 2;
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
            });
        });
        context(@"dataBytesRemaining is 1", ^{
            it(@"transitions to START_STATE", ^{
                testProcessor.dataBytesRemaining = 1;
                
                [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                    //do nothing?
                }];
                expect(@(testProcessor.state)).to(equal(START_STATE));
            });
        });
    });
});
    

QuickSpecEnd
