//  SDLProtocolReceivedMessageRouter.m
//

//  This class gets handed the SDLProtocol messages as they are received and decides what happens to them and where they are sent on to.

#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLLogMacros.h"
#import "SDLProtocolMessage.h"
#import "SDLProtocolMessageAssembler.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolReceivedMessageRouter ()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, SDLProtocolMessageAssembler *> *messageAssemblers;

@end


@implementation SDLProtocolReceivedMessageRouter

- (instancetype)init {
    if (self = [super init]) {
        self.messageAssemblers = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
}

- (void)handleReceivedMessage:(SDLProtocolMessage *)message protocol:(SDLProtocol *)protocol {
    SDLFrameType frameType = message.header.frameType;

    switch (frameType) {
        case SDLFrameTypeSingle: {
            [self sdl_dispatchProtocolMessage:message protocol:protocol];
        } break;
        case SDLFrameTypeControl: {
            [self sdl_dispatchControlMessage:message protocol:protocol];
        } break;
        case SDLFrameTypeFirst: // fallthrough
        case SDLFrameTypeConsecutive: {
            [self sdl_dispatchMultiPartMessage:message protocol:protocol];
        } break;
        default: break;
    }
}

- (void)sdl_dispatchProtocolMessage:(SDLProtocolMessage *)message protocol:(SDLProtocol *)protocol {
    if ([self.delegate respondsToSelector:@selector(onProtocolMessageReceived:protocol:)]) {
        [self.delegate onProtocolMessageReceived:message protocol:protocol];
    }
}

- (void)sdl_dispatchControlMessage:(SDLProtocolMessage *)message protocol:(SDLProtocol *)protocol {
    switch (message.header.frameData) {
        case SDLFrameInfoStartServiceACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolStartServiceACKMessage:protocol:)]) {
                [self.delegate handleProtocolStartServiceACKMessage:message protocol:protocol];
            }
        } break;
        case SDLFrameInfoStartServiceNACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolStartServiceNAKMessage:protocol:)]) {
                [self.delegate handleProtocolStartServiceNAKMessage:message protocol:protocol];
            }
        } break;
        case SDLFrameInfoEndServiceACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolEndServiceACKMessage:protocol:)]) {
                [self.delegate handleProtocolEndServiceACKMessage:message protocol:protocol];
            }
        } break;
        case SDLFrameInfoEndServiceNACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolEndServiceNAKMessage:protocol:)]) {
                [self.delegate handleProtocolEndServiceNAKMessage:message protocol:protocol];
            }
        } break;
        case SDLFrameInfoRegisterSecondaryTransportACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolRegisterSecondaryTransportACKMessage:protocol:)]) {
                [self.delegate handleProtocolRegisterSecondaryTransportACKMessage:message protocol:protocol];
            }
        } break;
        case SDLFrameInfoRegisterSecondaryTransportNACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolRegisterSecondaryTransportNAKMessage:protocol:)]) {
                [self.delegate handleProtocolRegisterSecondaryTransportNAKMessage:message protocol:protocol];
            }
        } break;
        case SDLFrameInfoHeartbeat: {
            if ([self.delegate respondsToSelector:@selector(handleHeartbeatForSession:)]) {
                [self.delegate handleHeartbeatForSession:message.header.sessionID];
            }
        } break;
        case SDLFrameInfoHeartbeatACK: {
            if ([self.delegate respondsToSelector:@selector(handleHeartbeatACK)]) {
                [self.delegate handleHeartbeatACK];
            }
        } break;
        case SDLFrameInfoTransportEventUpdate: {
            if ([self.delegate respondsToSelector:@selector(handleTransportEventUpdateMessage:protocol:)]) {
                [self.delegate handleTransportEventUpdateMessage:message protocol:protocol];
            }
        } break;
        default: break; // Other frame data is possible, but we don't care about them
    }
}

- (void)sdl_dispatchMultiPartMessage:(SDLProtocolMessage *)message protocol:(SDLProtocol *)protocol {
    // Pass multipart messages to an assembler and call delegate when done.
    NSNumber *sessionID = [NSNumber numberWithUnsignedChar:message.header.sessionID];

    SDLProtocolMessageAssembler *assembler = self.messageAssemblers[sessionID];
    if (assembler == nil) {
        assembler = [[SDLProtocolMessageAssembler alloc] initWithSessionID:message.header.sessionID];
        self.messageAssemblers[sessionID] = assembler;
    }

    SDLMessageAssemblyCompletionHandler completionHandler = ^void(BOOL done, SDLProtocolMessage *assembledMessage) {
        if (done) {
            [self sdl_dispatchProtocolMessage:assembledMessage protocol:protocol];
        }
    };
    [assembler handleMessage:message withCompletionHandler:completionHandler];
}

@end

NS_ASSUME_NONNULL_END
