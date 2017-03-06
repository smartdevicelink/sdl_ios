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
                                 [self sdl_fileManagerModule],
                                 [self sdl_lifecycleManagerModule],
                                 [self sdl_lockscreenManagerModule],
                                 [self sdl_streamingMediaManagerModule]]];
}

+ (SDLLogFileModule *)sdl_transportModule {
    return [SDLLogFileModule moduleWithName:@"Transport" files:[NSSet setWithArray:@[@"SDLIAPSession", @"SDLIAPTransport", @"SDLStreamDelegate", @"SDLTCPTransport"]]];
}

+ (SDLLogFileModule *)sdl_proxyModule {
    return [SDLLogFileModule moduleWithName:@"Proxy" files:[NSSet setWithArray:@[@"SDLProxy", @"SDLPolicyDataParser"]]];
}

+ (SDLLogFileModule *)sdl_protocolModule {
    return [SDLLogFileModule moduleWithName:@"Protocol" files:[NSSet setWithArray:@[@"SDLProtocol", @"SDLProtocolMessageAssembler", @"SDLV1ProtocolMessage", @"SDLV2ProtocolMessage"]]];
}

+ (SDLLogFileModule *)sdl_rpcModule {
    return [SDLLogFileModule moduleWithName:@"RPC" files:[NSSet setWithArray:@[@"SDLRPCPayload"]]];
}


#pragma mark Managers

+ (SDLLogFileModule *)sdl_fileManagerModule {
    return [SDLLogFileModule moduleWithName:@"File" files:[NSSet setWithArray:@[@"SDLFileManager"]]];
}

+ (SDLLogFileModule *)sdl_lifecycleManagerModule {
    return [SDLLogFileModule moduleWithName:@"Lifecycle" files:[NSSet setWithArray:@[@"SDLLifecycleManager"]]];
}

+ (SDLLogFileModule *)sdl_lockscreenManagerModule {
    return [SDLLogFileModule moduleWithName:@"Lockscreen" files:[NSSet setWithArray:@[@"SDLLockScreenManager"]]];
}

+ (SDLLogFileModule *)sdl_streamingMediaManagerModule {
    return [SDLLogFileModule moduleWithName:@"Streaming" files:[NSSet setWithArray:@[@"SDLStreamingMediaManager"]]];
}

@end
