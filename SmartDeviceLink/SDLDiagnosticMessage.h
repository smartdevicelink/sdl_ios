//  SDLDiagnosticMessage.h
//


#import "SDLRPCRequest.h"

/** 
 * Non periodic vehicle diagnostic request
 *
 * @since SDL 3.0
 */
@interface SDLDiagnosticMessage : SDLRPCRequest

/**
 * Name of target ECU
 *
 * Required, Integer, 0 - 65535
 */
@property (strong) NSNumber<SDLInt> *targetID;

/**
 * Length of message (in bytes)
 *
 * Required, Integer, 65535
 */
@property (strong) NSNumber<SDLInt> *messageLength;

/**
 *  Array of bytes comprising CAN message.
 *
 * Required, Array of NSNumber (Integers), Array size 1 - 65535, Integer Size 0 - 255
 */
@property (strong) NSMutableArray<NSNumber<SDLInt> *> *messageData;

@end
