//  SDLSmartDeviceLinkProtocolMessageAssembler.m
//

#import "SDLProtocolMessageAssembler.h"

#import "SDLDebugTool.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"

@implementation SDLProtocolMessageAssembler

- (instancetype)initWithSessionID:(UInt8)sessionID {
    if (self = [super init]) {
        _sessionID = sessionID;
    }
    return self;
}

- (void)handleMessage:(SDLProtocolMessage *)message withCompletionHandler:(SDLMessageAssemblyCompletionHandler)completionHandler {
    // Validate input
    if (message.header.sessionID != self.sessionID) {
        [SDLDebugTool logInfo:@"Error: message part sent to wrong assembler."];
        return;
    }

    if (self.parts == nil) {
        self.parts = [NSMutableDictionary new];
    }


    // Determine which frame it is and save it.
    // Note: frames are numbered 1,2,3, ..., 0
    // Always 0 for last frame.
    if (message.header.frameType == SDLFrameType_First) {
        // If it's the first-frame, extract the meta-data
        self.expectedBytes = NSSwapBigIntToHost(((UInt32 *)message.payload.bytes)[0]);
        self.frameCount = NSSwapBigIntToHost(((UInt32 *)message.payload.bytes)[1]);
        self.parts[@"firstframe"] = message.payload;
    } else if (message.header.frameType == SDLFrameType_Consecutive) {
        // Save the frame w/ frame# as the key
        NSInteger frameNumber = message.header.frameData;
        NSNumber *frameNumberObj = @(frameNumber);
        self.parts[frameNumberObj] = message.payload;
    }


    //
    // If we have all the parts, assemble it and execute the completion handler.
    //
    SDLProtocolMessage *assembledMessage = nil;
    if (self.parts.count == self.frameCount + 1) { // +1 since we also require the first-frame

        // Create the header
        SDLProtocolHeader *header = message.header.copy;
        header.frameType = SDLFrameType_Single;
        header.frameData = SDLFrameData_SingleFrame;


        // Create the payload
        NSMutableData *payload = [[NSMutableData alloc] init];
        for (unsigned int i = 1; i < self.frameCount; i++) {
            NSData *dataToAppend = [self.parts objectForKey:[NSNumber numberWithUnsignedInt:i]];
            [payload appendData:dataToAppend];
        }
        // Append the last frame, it has a frame # of 0.
        NSData *dataToAppend = [self.parts objectForKey:[NSNumber numberWithUnsignedInt:0]];
        [payload appendData:dataToAppend];

        // Validation
        header.bytesInPayload = (UInt32)payload.length;
        if (payload.length != self.expectedBytes) {
            [SDLDebugTool logFormat:@"Warning: collected bytes size of %lu not equal to expected size of %i.", (unsigned long)payload.length, (unsigned int)self.expectedBytes];
        }

        // Create the message.
        assembledMessage = [SDLProtocolMessage messageWithHeader:header andPayload:payload];


        // Execute completion handler.
        if (completionHandler != nil) {
            completionHandler(YES, assembledMessage);
        }

        // Done with this data, release it.
        self.parts = nil;

    } else {
        // Not done, let caller know
        if (completionHandler != nil) {
            completionHandler(NO, nil);
        }
    }
}

@end
