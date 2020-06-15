//
//  SDLLifecycleRPCAdapter.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/15/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleRPCAdapter.h"

#import "SDLGlobals.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCMessage.h"
#import "SDLSubscribeButton.h"
#import "SDLUnsubscribeButton.h"
#import "SDLVersion.h"

@implementation SDLLifecycleRPCAdapter

+ (NSArray<SDLRPCMessage *> *)adaptRPC:(SDLRPCMessage *)message {
    if ([message.name isEqualToEnum:SDLRPCFunctionNameSubscribeButton]) {
        return [self adaptSubscribeButton:(SDLSubscribeButton *)message];
    } else if ([message.name isEqualToEnum:SDLRPCFunctionNameUnsubscribeButton]) {
        return [self adaptUnsubscribeButton:(SDLUnsubscribeButton *)message];
    } else if ([message.name isEqualToEnum:SDLRPCFunctionNameOnButtonPress]) {
        return [self adaptOnButtonPress:(SDLOnButtonPress *)message];
    } else if ([message.name isEqualToEnum:SDLRPCFunctionNameOnButtonEvent]) {
        return [self adaptOnButtonEvent:(SDLOnButtonEvent *)message];
    }

    return @[message];
}

#pragma mark - Individual RPC Adaptations

#pragma mark Requests

+ (NSArray<SDLRPCMessage *> *)adaptSubscribeButton:(SDLSubscribeButton *)message {
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            SDLSubscribeButton *playPauseMessage = [message copy];
            playPauseMessage.buttonName = SDLButtonNamePlayPause;

            return @[message, playPauseMessage];
        }
    } else { // Major version < 5
        if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            SDLSubscribeButton *okMessage = [message copy];
            okMessage.buttonName = SDLButtonNameOk;

            return @[okMessage];
        }
    }

    return @[message];
}

+ (NSArray<SDLRPCMessage *> *)adaptUnsubscribeButton:(SDLUnsubscribeButton *)message {
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            SDLUnsubscribeButton *playPauseMessage = [message copy];
            playPauseMessage.buttonName = SDLButtonNamePlayPause;

            return @[message, playPauseMessage];
        }
    } else { // Major version < 5
        if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            SDLUnsubscribeButton *okMessage = [message copy];
            okMessage.buttonName = SDLButtonNameOk;

            return @[okMessage];
        }
    }

    return @[message];
}

#pragma mark Notifications

+ (NSArray<SDLRPCMessage *> *)adaptOnButtonPress:(SDLOnButtonPress *)message {
    // Drop PlayPause, this shouldn't come in
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            // Send PlayPause & OK notifications
            SDLOnButtonPress *okPress = [message copy];
            okPress.buttonName = SDLButtonNameOk;

            return @[message, okPress];
        } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            // Send PlayPause and OK notifications
            SDLOnButtonPress *playPausePress = [message copy];
            playPausePress.buttonName = SDLButtonNamePlayPause;

            return @[message, playPausePress];
        }
    } else {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            // Send Ok and Play/Pause notifications
            SDLOnButtonPress *playPausePress = [message copy];
            playPausePress.buttonName = SDLButtonNamePlayPause;

            return @[message, playPausePress];
        }
    }

    return @[message];
}

+ (NSArray<SDLRPCMessage *> *)adaptOnButtonEvent:(SDLOnButtonEvent *)message {
    // Drop PlayPause, this shouldn't come in
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            // Send PlayPause & OK notifications
            SDLOnButtonEvent *okEvent = [message copy];
            okEvent.buttonName = SDLButtonNameOk;

            return @[message, okEvent];
        } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            // Send PlayPause and OK notifications
            SDLOnButtonEvent *playPauseEvent = [message copy];
            playPauseEvent.buttonName = SDLButtonNamePlayPause;

            return @[message, playPauseEvent];
        }
    } else {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            // Send Ok and Play/Pause notifications
            SDLOnButtonEvent *playPauseEvent = [message copy];
            playPauseEvent.buttonName = SDLButtonNamePlayPause;

            return @[message, playPauseEvent];
        }
    }

    return @[message];
}

@end
