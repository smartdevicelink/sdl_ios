//
//  SDLLogConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogConfiguration.h"

#import "SDLLogFileModule.h"
#import "SDLLogTargetASL.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLLogConfiguration

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _modules = [NSSet set];
    _targets = [NSSet setWithArray:@[[SDLLogTargetASL logger]]];
    _filters = [NSSet set];
    _formatType = SDLLogFormatTypeDefault;
    _asynchronous = YES;
    _errorsAsynchronous = NO;
    _globalLogLevel = SDLLogLevelError;

    return self;
}

- (instancetype)initWithDefaultConfiguration {
    return [self init];
}

+ (instancetype)defaultConfiguration {
    return [[self.class alloc] initWithDefaultConfiguration];
}

- (instancetype)initWithDebugConfiguration {
    self = [self init];
    if (!self) { return nil; }

    _formatType = SDLLogFormatTypeDetailed;
    _globalLogLevel = SDLLogLevelDebug;
    _targets = [NSSet setWithArray:@[[SDLLogTargetASL logger]]];

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
    newConfig.globalLogLevel = self.globalLogLevel;

    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
