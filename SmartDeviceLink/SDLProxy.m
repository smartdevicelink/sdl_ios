// SDLProxy.m

#import "SDLProxy.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "SDLAudioStreamingState.h"
#import "SDLLogMacros.h"
#import "SDLEncodedSyncPData.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLFileType.h"
#import "SDLFunctionID.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLIAPTransport.h"
#import "SDLLanguage.h"
#import "SDLLayoutMode.h"
#import "SDLLockScreenStatusManager.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemRequest.h"
#import "SDLPolicyDataParser.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPutFile.h"
#import "SDLRPCPayload.h"
#import "SDLRPCResponse.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRequestType.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLStreamingMediaManager.h"
#import "SDLSubscribeButton.h"
#import "SDLSystemContext.h"
#import "SDLSystemRequest.h"
#import "SDLTCPTransport.h"
#import "SDLTimer.h"
#import "SDLTransportType.h"
#import "SDLUnsubscribeButton.h"
#import "SDLVehicleType.h"
#import "SDLVersion.h"
#import "SDLCacheFileManager.h"

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const SDLProxyVersion = @"6.6.0";

@end


@implementation SDLProxy

#pragma mark - Setters / Getters

- (NSString *)proxyVersion {
    return SDLProxyVersion;
}


#pragma mark - Message sending

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)sdl_adaptButtonSubscribeMessage:(SDLSubscribeButton *)message {
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            SDLSubscribeButton *playPauseMessage = [message copy];
            playPauseMessage.buttonName = SDLButtonNamePlayPause;

            @try {
                [self.protocol sendRPC:message];
                [self.protocol sendRPC:playPauseMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            return NO;
        }
    } else { // Major version < 5
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            return NO;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            SDLSubscribeButton *okMessage = [message copy];
            okMessage.buttonName = SDLButtonNameOk;

            @try {
                [self.protocol sendRPC:okMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        }
    }

    return NO;
}

- (BOOL)sdl_adaptButtonUnsubscribeMessage:(SDLUnsubscribeButton *)message {
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            SDLUnsubscribeButton *playPauseMessage = [message copy];
            playPauseMessage.buttonName = SDLButtonNamePlayPause;

            @try {
                [self.protocol sendRPC:message];
                [self.protocol sendRPC:playPauseMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            return NO;
        }
    } else { // Major version < 5
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            return NO;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            SDLUnsubscribeButton *okMessage = [message copy];
            okMessage.buttonName = SDLButtonNameOk;

            @try {
                [self.protocol sendRPC:okMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        }
    }

    return NO;
}
#pragma clang diagnostic pop

#pragma mark - Message Receiving

- (void)handleRPCDictionary:(NSDictionary<NSString *, id> *)dict {
    // Intercept and handle several messages ourselves

    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
        [self handleRegisterAppInterfaceResponse:(SDLRPCResponse *)newMessage];
    }

    if ([functionName isEqualToString:@"OnButtonPress"]) {
        SDLOnButtonPress *message = (SDLOnButtonPress *)newMessage;
        if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
            BOOL handledRPC = [self sdl_handleOnButtonPressPostV5:message];
            if (handledRPC) { return; }
        } else { // RPC version of 4 or less (connected to an old head unit)
            BOOL handledRPC = [self sdl_handleOnButtonPressPreV5:message];
            if (handledRPC) { return; }
        }
    }

    if ([functionName isEqualToString:@"OnButtonEvent"]) {
        SDLOnButtonEvent *message = (SDLOnButtonEvent *)newMessage;
        if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
            BOOL handledRPC = [self sdl_handleOnButtonEventPostV5:message];
            if (handledRPC) { return; }
        } else {
            BOOL handledRPC = [self sdl_handleOnButtonEventPreV5:message];
            if (handledRPC) { return; }
        }
    }

//    [self sdl_invokeDelegateMethodsWithFunction:functionName message:newMessage];

    // When an OnHMIStatus notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnHMIStatus"]) {
        [self sdl_handleAfterHMIStatus:newMessage];
    }

    // When an OnDriverDistraction notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnDriverDistraction"]) {
        [self sdl_handleAfterDriverDistraction:newMessage];
    }
}

#pragma mark BackCompatability ButtonName Helpers

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)sdl_handleOnButtonPressPreV5:(SDLOnButtonPress *)message {
    // Drop PlayPause, this shouldn't come in
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send Ok and Play/Pause notifications
        SDLOnButtonPress *playPausePress = [message copy];
        playPausePress.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPausePress];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}

- (BOOL)sdl_handleOnButtonPressPostV5:(SDLOnButtonPress *)message {
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        // Send PlayPause & OK notifications
        SDLOnButtonPress *okPress = [message copy];
        okPress.buttonName = SDLButtonNameOk;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:okPress];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send PlayPause and OK notifications
        SDLOnButtonPress *playPausePress = [message copy];
        playPausePress.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPausePress];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}

- (BOOL)sdl_handleOnButtonEventPreV5:(SDLOnButtonEvent *)message {
    // Drop PlayPause, this shouldn't come in
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send Ok and Play/Pause notifications
        SDLOnButtonEvent *playPauseEvent = [message copy];
        playPauseEvent.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPauseEvent];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}

- (BOOL)sdl_handleOnButtonEventPostV5:(SDLOnButtonEvent *)message {
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        // Send PlayPause & OK notifications
        SDLOnButtonEvent *okEvent = [message copy];
        okEvent.buttonName = SDLButtonNameOk;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:okEvent];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send PlayPause and OK notifications
        SDLOnButtonEvent *playPauseEvent = [message copy];
        playPauseEvent.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPauseEvent];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
