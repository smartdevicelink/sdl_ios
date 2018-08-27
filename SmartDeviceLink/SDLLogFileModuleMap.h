//
//  SDLLogFileModuleMap.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLogFileModule;

@interface SDLLogFileModuleMap : NSObject

+ (NSSet<SDLLogFileModule *> *)sdlModuleMap;

@end
