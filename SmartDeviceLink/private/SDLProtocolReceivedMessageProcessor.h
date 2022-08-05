//
//  SDLProtocolReceivedMessageProcessor.h
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLProtocolHeader;

/**
 * Handles decryption and creation of the message from header and payload.  Decryption needed to be handled outside of the MessageProcessor because of access to the securitymanager.
 * @param header Pointer to the header for the message
 * @param payload Pointer to the payload of the message
 */
typedef void (^StateMachineMessageReadyBlock)(SDLProtocolHeader *header, NSData *payload);

/// Class for processing received byte data into protocol messages
@interface SDLProtocolReceivedMessageProcessor : NSObject

/**
 * Processes a data buffer into the state machine.
 * Loop through the given bytes and call the state machine to process each byte.
 * @param receiveBuffer Holds the incoming bytes from the receive buffer
 * @param messageReadyBlock Passes back a completed protocol message when one has been assembled
 */
-(void)processReceiveBuffer:(NSData *)receiveBuffer withMessageReadyBlock:(StateMachineMessageReadyBlock)messageReadyBlock;

@end
