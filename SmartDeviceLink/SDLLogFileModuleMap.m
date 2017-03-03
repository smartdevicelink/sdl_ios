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
                                 [self sdl_lockscreenManagerModule]]];
}

+ (SDLLogFileModule *)sdl_transportModule {
    return [SDLLogFileModule moduleWithName:@"Transport" files:[NSSet setWithArray:@[@"SDLIAPSession", @"SDLIAPTransport"]]];
}

+ (SDLLogFileModule *)sdl_proxyModule {
    return [SDLLogFileModule moduleWithName:@"Proxy" files:[NSSet setWithArray:@[@"SDLProxy", @"SDLPolicyDataParser"]]];
}

+ (SDLLogFileModule *)sdl_protocolModule {
    return [SDLLogFileModule moduleWithName:@"Protocol" files:[NSSet setWithArray:@[@"SDLProtocol"]]];
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

@end
