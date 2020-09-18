//
//  SDLLogConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogConfiguration.h"

#import "SDLLogFileModule.h"
#import "SDLLogFileModuleMap.h"
#import "SDLLogTargetAppleSystemLog.h"
#import "SDLLogTargetOSLog.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLLogConfiguration

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _modules = [NSSet set];
    _targets = [NSSet set];
    _filters = [NSSet set];
    _formatType = SDLLogFormatTypeDefault;
    _asynchronous = YES;
    _errorsAsynchronous = NO;
    _disableAssertions = NO;
    _globalLogLevel = SDLLogLevelError;

    return self;
}

- (instancetype)initWithDefaultConfiguration {
    self = [self init];
    if (!self) {
        return nil;
    }

    _targets = [NSSet setWithArray:@[[SDLLogTargetOSLog logger]]];
    _modules = [SDLLogFileModuleMap sdlModuleMap];

    return self;
}

+ (instancetype)defaultConfiguration {
    return [[self.class alloc] initWithDefaultConfiguration];
}

- (instancetype)initWithDebugConfiguration {
    self = [self initWithDefaultConfiguration];
    if (!self) { return nil; }

    _formatType = SDLLogFormatTypeDetailed;
    _globalLogLevel = SDLLogLevelDebug;

    return self;
}

+ (instancetype)debugConfiguration {
    return [[self.class alloc] initWithDebugConfiguration];
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLogConfiguration *newConfig = [[self.class allocWithZone:zone] init];
    newConfig.modules = self.modules;
    newConfig.targets = self.targets;
    newConfig.filters = self.filters;
    newConfig.formatType = self.formatType;
    newConfig.asynchronous = self.asynchronous;
    newConfig.errorsAsynchronous = self.errorsAsynchronous;
    newConfig.disableAssertions = self.areAssertionsDisabled;
    newConfig.globalLogLevel = self.globalLogLevel;

    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
