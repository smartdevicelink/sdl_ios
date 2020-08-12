//
//  SDLLogFileModuleMap.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogFileModuleMap.h"

#import "SDLLogFileModule.h"

@implementation SDLLogFileModuleMap

+ (NSSet<SDLLogFileModule *> *)sdlModuleMap {
    return [NSSet setWithArray:@[[self sdl_transportModule],
                                 [self sdl_tcpTransportModule],
                                 [self sdl_iapTransportModule],
                                 [self sdl_secondaryTransportModule],
                                 [self sdl_protocolModule],
                                 [self sdl_rpcModule],
                                 [self sdl_dispatcherModule],
                                 [self sdl_fileManagerModule],
                                 [self sdl_encryptionLifecycleManagerModule],
                                 [self sdl_lifecycleManagerModule],
                                 [self sdl_systemCapabilityModule],
                                 [self sdl_lockscreenManagerModule],
                                 [self sdl_streamingMediaManagerModule],
                                 [self sdl_videoStreamingMediaManagerModule],
                                 [self sdl_videoStreamingMediaTranscoderModule],
                                 [self sdl_audioStreamingMediaManagerModule],
                                 [self sdl_audioStreamingMediaTranscoderModule],
                                 [self sdl_screenManagerModule],
                                 [self sdl_screenManagerTextAndGraphicModule],
                                 [self sdl_screenManagerSoftButtonModule],
                                 [self sdl_screenManagerSubscribeButtonModule],
                                 [self sdl_screenManagerMenuModule],
                                 [self sdl_screenManagerChoiceSetModule],
                                 [self sdl_utilitiesModule]]];
}

#pragma mark Transport

+ (SDLLogFileModule *)sdl_transportModule {
    return [SDLLogFileModule moduleWithName:@"Transport" files:[NSSet setWithArray:@[@"SDLStreamDelegate"]]];
}

+ (SDLLogFileModule *)sdl_tcpTransportModule {
    return [SDLLogFileModule moduleWithName:@"Transport/TCP" files:[NSSet setWithArray:@[@"SDLTCPTransport"]]];
}

+ (SDLLogFileModule *)sdl_iapTransportModule {
    return [SDLLogFileModule moduleWithName:@"Transport/IAP" files:[NSSet setWithArray:@[@"SDLIAPSession", @"SDLIAPTransport", @"SDLIAPDataSession", @"SDLIAPControlSession"]]];
}

+ (SDLLogFileModule *)sdl_secondaryTransportModule {
    return [SDLLogFileModule moduleWithName:@"Transport/Secondary" files:[NSSet setWithArray:@[@"SDLSecondaryTransportManager"]]];
}

#pragma mark Low-Level

+ (SDLLogFileModule *)sdl_protocolModule {
    return [SDLLogFileModule moduleWithName:@"Protocol" files:[NSSet setWithArray:@[@"SDLProtocol", @"SDLProtocolMessageAssembler", @"SDLProtocolMessageDisassembler", @"SDLProtocolReceivedMessageRouter", @"SDLV1ProtocolMessage", @"SDLV2ProtocolMessage", @"SDLV1ProtocolHeader", @"SDLV2ProtocolHeader", @"SDLGlobals"]]];
}

+ (SDLLogFileModule *)sdl_rpcModule {
    return [SDLLogFileModule moduleWithName:@"RPC" files:[NSSet setWithArray:@[@"SDLRPCPayload", @"NSMutableDictionary+Store"]]];
}

#pragma mark Managers

+ (SDLLogFileModule *)sdl_dispatcherModule {
    return [SDLLogFileModule moduleWithName:@"Dispatcher" files:[NSSet setWithArray:@[@"SDLNotificationDispatcher", @"SDLResponseDispatcher"]]];
}

+ (SDLLogFileModule *)sdl_fileManagerModule {
    return [SDLLogFileModule moduleWithName:@"File" files:[NSSet setWithArray:@[@"SDLFileManager", @"SDLFile", @"SDLArtwork", @"SDLListFilesOperation", @"SDLUploadFileOperation", @"SDLDeleteFileOperation"]]];
}

+ (SDLLogFileModule *)sdl_encryptionLifecycleManagerModule {
    return [SDLLogFileModule moduleWithName:@"Encryption" files:[NSSet setWithArray:@[@"SDLEncryptionLifecycleManager", @"SDLEncryptionConfiguration", @"SDLEncryptionManagerConstants"]]];
}

+ (SDLLogFileModule *)sdl_lifecycleManagerModule {
    return [SDLLogFileModule moduleWithName:@"Lifecycle" files:[NSSet setWithArray:@[@"SDLLifecycleManager", @"SDLManager", @"SDLAsynchronousOperation", @"SDLBackgroundTaskManager", @"SDLPolicyDataParser", @"SDLLifecycleProtocolHandler", @"SDLLifecycleRPCAdapter", @"SDLLifecycleSyncPDataHandler", @"SDLLifecycleSystemRequestHandler", @"SDLLifecycleMobileHMIStateHandler"]]];
}

+ (SDLLogFileModule *)sdl_systemCapabilityModule {
    return [SDLLogFileModule moduleWithName:@"System Capability" files:[NSSet setWithArray:@[@"SDLSystemCapabilityManager"]]];
}

+ (SDLLogFileModule *)sdl_lockscreenManagerModule {
    return [SDLLogFileModule moduleWithName:@"Lockscreen" files:[NSSet setWithArray:@[@"SDLLockScreenManager", @"SDLLockScreenViewController", @"SDLLockScreenPresenter", @"SDLCacheFileManager", @"SDLLockScreenStatusManager"]]];
}

+ (SDLLogFileModule *)sdl_streamingMediaManagerModule {
    return [SDLLogFileModule moduleWithName:@"Audio and Video Streaming" files:[NSSet setWithArray:@[@"SDLStreamingMediaManager"]]];
}

+ (SDLLogFileModule *)sdl_videoStreamingMediaManagerModule {
    return [SDLLogFileModule moduleWithName:@"Video Streaming" files:[NSSet setWithArray:@[@"SDLStreamingVideoLifecycleManager", @"SDLTouchManager", @"SDLCarWindow", @"SDLFocusableItemLocator"]]];
}

+ (SDLLogFileModule *)sdl_videoStreamingMediaTranscoderModule {
    return [SDLLogFileModule moduleWithName:@"Video Streaming/Transcoding" files:[NSSet setWithArray:@[@"SDLH264VideoEncoder", @"SDLRAWH264Packetizer", @"SDLRTPH264Packetizer"]]];
}

+ (SDLLogFileModule *)sdl_audioStreamingMediaManagerModule {
    return [SDLLogFileModule moduleWithName:@"Audio Streaming" files:[NSSet setWithArray:@[@"SDLStreamingAudioLifecycleManager"]]];
}

+ (SDLLogFileModule *)sdl_audioStreamingMediaTranscoderModule {
    return [SDLLogFileModule moduleWithName:@"Audio Streaming/Transcoding" files:[NSSet setWithArray:@[@"SDLAudioStreamManager", @"SDLPCMAudioConverter"]]];
}

+ (SDLLogFileModule *)sdl_screenManagerModule {
    return [SDLLogFileModule moduleWithName:@"Screen" files:[NSSet setWithArray:@[@"SDLScreenManager"]]];
}

+ (SDLLogFileModule *)sdl_screenManagerTextAndGraphicModule {
    return [SDLLogFileModule moduleWithName:@"Screen/TextAndGraphic" files:[NSSet setWithArray:@[@"SDLTextAndGraphicManager"]]];
}

+ (SDLLogFileModule *)sdl_screenManagerSoftButtonModule {
    return [SDLLogFileModule moduleWithName:@"Screen/SoftButton" files:[NSSet setWithArray:@[@"SDLSoftButtonManager", @"SDLSoftButtonObject", @"SDLSoftButtonState", @"SDLSoftButtonTransitionOperation", @"SDLSoftButtonReplaceOperation"]]];
}

+ (SDLLogFileModule *)sdl_screenManagerSubscribeButtonModule {
    return [SDLLogFileModule moduleWithName:@"Screen/SubscribeButton" files:[NSSet setWithArray:@[@"SDLSubscribeButtonManager", @"SDLSubscribeButtonObserver"]]];
}

+ (SDLLogFileModule *)sdl_screenManagerMenuModule {
    return [SDLLogFileModule moduleWithName:@"Screen/Menu" files:[NSSet setWithArray:@[@"SDLMenuManager", @"SDLVoiceCommandManager"]]];
}

+ (SDLLogFileModule *)sdl_screenManagerChoiceSetModule {
    return [SDLLogFileModule moduleWithName:@"Screen/ChoiceSet" files:[NSSet setWithArray:@[@"SDLChoiceSetManager", @"SDLCheckChoiceVROptionalOperation", @"SDLDeleteChoicesOperation", @"SDLPreloadChoicesOperation", @"SDLPresentChoiceSetOperation", @"SDLPresentKeyboardOperation", @"SDLChoiceSet"]]];
}


#pragma mark Utilities

+ (SDLLogFileModule *)sdl_utilitiesModule {
    return [SDLLogFileModule moduleWithName:@"Utilities" files:[NSSet setWithArray:@[@"SDLStateMachine"]]];
}

@end
