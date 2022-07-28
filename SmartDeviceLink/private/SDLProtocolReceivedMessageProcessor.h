//
//  SDLProtocolReceivedMessageProcessor.h
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//


/**
 * Handles decryption and creation of the message from header and payload
 */
typedef void (^StateMachineMessageReadyBlock)(BOOL, SDLProtocolHeader *, NSData *);

@interface SDLProtocolReceivedMessageProcessor : NSObject

/**
 * Buffer for holding the header of a message
 */
@property (strong, nonatomic) NSMutableData *headerBuffer;

/**
 * Buffer for holding the payload of a message
 */
@property (strong, nonatomic) NSMutableData *payloadBuffer;

/**
 * Processes the reveive buffer into the state machine.
 * Loop through the given bytes and call the state machine to process each byte.
 * @param receiveBuffer Holds the incoming bytes from the receive buffer
 * @param completionBlock Handles decryption and creation of the message from header and payload
 */
-(void)processReceiveBuffer:(NSData *)receiveBuffer withMessageReadyBlock:(StateMachineMessageReadyBlock)completionBlock;

@end
