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
    return [NSSet setWithArray:@[[self sdl_transportModule], [self sdl_fileManagerModule]]];
}

+ (SDLLogFileModule *)sdl_transportModule {
    return [SDLLogFileModule moduleWithName:@"Transport" files:[NSSet setWithArray:@[]]];
}

+ (SDLLogFileModule *)sdl_fileManagerModule {
    return [SDLLogFileModule moduleWithName:@"File Manager" files:[NSSet setWithArray:@[]]];
}

@end
