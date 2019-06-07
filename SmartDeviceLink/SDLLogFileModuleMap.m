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
                                 [self sdl_proxyModule],
                                 [self sdl_protocolModule],
                                 [self sdl_rpcModule],
                                 [self sdl_dispatcherModule],
                                 [self sdl_fileManagerModule],
                                 [self sdl_lifecycleManagerModule],
                                 [self sdl_systemCapabilityModule],
                                 [self sdl_lockscreenManagerModule],
                                 [self sdl_streamingMediaManagerModule],
                                 [self sdl_streamingMediaAudioTranscoderModule],
                                 [self sdl_screenManagerModule],
                                 [self sdl_screenManagerTextAndGraphicModule],
                                 [self sdl_screenManagerSoftButtonModule],
                                 [self sdl_screenManagerMenuModule],
                                 [self sdl_screenManagerChoiceSetModule],
                                 [self sdl_utilitiesModule]]];
}

+ (SDLLogFileModule *)sdl_transportModule {
    return [SDLLogFileModule moduleWithName:@"Transport" files:[NSSet setWithArray:@[@"SDLIAPSession", @"SDLIAPTransport", @"SDLIAPDataSession", @"SDLIAPControlSession", @"SDLSecondaryTransportManager", @"SDLSecondaryTransportPrimaryProtocolHandler", @"SDLStreamDelegate", @"SDLTCPTransport"]]];
}

+ (SDLLogFileModule *)sdl_proxyModule {
    return [SDLLogFileModule moduleWithName:@"Proxy" files:[NSSet setWithArray:@[@"SDLProxy", @"SDLPolicyDataParser"]]];
}

+ (SDLLogFileModule *)sdl_protocolModule {
    return [SDLLogFileModule moduleWithName:@"Protocol" files:[NSSet setWithArray:@[@"SDLProtocol", @"SDLProtocolMessageAssembler", @"SDLProtocolMessageDisassembler", @"SDLProtocolReceivedMessageRouter", @"SDLV1ProtocolMessage", @"SDLV2ProtocolMessage", @"SDLV1ProtocolHeader", @"SDLV2ProtocolHeader"]]];
}

+ (SDLLogFileModule *)sdl_rpcModule {
    return [SDLLogFileModule moduleWithName:@"RPC" files:[NSSet setWithArray:@[@"SDLRPCPayload", @"NSMutableDictionary+Store"]]];
}

+ (SDLLogFileModule *)sdl_dispatcherModule {
    return [SDLLogFileModule moduleWithName:@"Dispatcher" files:[NSSet setWithArray:@[@"SDLNotificationDispatcher", @"SDLResponseDispatcher"]]];
}


#pragma mark Managers

+ (SDLLogFileModule *)sdl_fileManagerModule {
    return [SDLLogFileModule moduleWithName:@"File" files:[NSSet setWithArray:@[@"SDLFileManager", @"SDLFile", @"SDLArtwork", @"SDLListFilesOperation", @"SDLUploadFileOperation", @"SDLDeleteFileOperation"]]];
}

+ (SDLLogFileModule *)sdl_lifecycleManagerModule {
    return [SDLLogFileModule moduleWithName:@"Lifecycle" files:[NSSet setWithArray:@[@"SDLLifecycleManager", @"SDLManager"]]];
}

+ (SDLLogFileModule *)sdl_systemCapabilityModule {
    return [SDLLogFileModule moduleWithName:@"System Capability" files:[NSSet setWithArray:@[@"SDLSystemCapabilityManager"]]];
}

+ (SDLLogFileModule *)sdl_lockscreenManagerModule {
    return [SDLLogFileModule moduleWithName:@"Lockscreen" files:[NSSet setWithArray:@[@"SDLLockScreenManager", @"SDLLockScreenViewController", @"SDLLockScreenPresenter"]]];
}

+ (SDLLogFileModule *)sdl_streamingMediaManagerModule {
    return [SDLLogFileModule moduleWithName:@"Streaming" files:[NSSet setWithArray:@[@"SDLH264VideoEncoder", @"SDLRAWH264Packetizer", @"SDLRTPH264Packetizer", @"SDLStreamingMediaManager", @"SDLStreamingAudioLifecycleManager", @"SDLStreamingVideoLifecycleManager", @"SDLTouchManager", @"SDLCarWindow"]]];
}

+ (SDLLogFileModule *)sdl_streamingMediaAudioTranscoderModule {
    return [SDLLogFileModule moduleWithName:@"Streaming/Audio Transcode" files:[NSSet setWithArray:@[@"SDLAudioStreamManager", @"SDLPCMAudioConverter"]]];
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
