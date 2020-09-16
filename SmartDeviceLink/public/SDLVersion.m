//
//  SDLVersion.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/19/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLVersion.h"

#import "SDLSyncMsgVersion.h"
#import "SDLMsgVersion.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLVersion

#pragma mark - Initializers

- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch {
    self = [super init];
    if (!self) { return nil; }

    _major = major;
    _minor = minor;
    _patch = patch;

    return self;
}

- (instancetype)initWithVersion:(NSUInteger)major :(NSUInteger)minor :(NSUInteger)patch {
    return [self initWithMajor:major minor:minor patch:patch];
}

+ (instancetype)versionWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch {
    return [[self alloc] initWithMajor:major minor:minor patch:patch];
}

+ (instancetype)version:(NSUInteger)major :(NSUInteger)minor :(NSUInteger)patch {
    return [[self alloc] initWithVersion:major:minor:patch];
}

- (nullable instancetype)initWithString:(NSString *)versionString {
    self = [super init];
    if (!self) { return nil; }

    NSArray<NSString *> *splitVersions = [versionString componentsSeparatedByString:@"."];
    if (splitVersions.count != 3) {
        NSAssert(splitVersions.count == 3, @"Splitting a version string must result in major, minor, and patch. The format must be 'X.X.X'");
        return nil;
    }

    NSInteger majorInt = splitVersions[0].integerValue;
    NSInteger minorInt = splitVersions[1].integerValue;
    NSInteger patchInt = splitVersions[2].integerValue;

    if (majorInt < 0 || minorInt < 0 || patchInt < 0) {
        NSAssert(NO, @"Attempted to parse invalid SDLVersion: %@", splitVersions);
        return nil;
    }

    _major = (NSUInteger)majorInt;
    _minor = (NSUInteger)minorInt;
    _patch = (NSUInteger)patchInt;

    return self;
}

+ (nullable instancetype)versionWithString:(NSString *)versionString {
    return [[self alloc] initWithString:versionString];
}

- (instancetype)initWithSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    self = [super init];
    if (!self) { return nil; }

    _major = syncMsgVersion.majorVersion.unsignedIntegerValue;
    _minor = syncMsgVersion.minorVersion.unsignedIntegerValue;
    _patch = syncMsgVersion.patchVersion.unsignedIntegerValue;

    return self;
}

+ (instancetype)versionWithSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    return [[self alloc] initWithSyncMsgVersion:syncMsgVersion];
}

- (instancetype)initWithSDLMsgVersion:(SDLMsgVersion *)sdlMsgVersion {
    self = [super init];
    if (!self) { return nil; }

    _major = sdlMsgVersion.majorVersion.unsignedIntegerValue;
    _minor = sdlMsgVersion.minorVersion.unsignedIntegerValue;
    _patch = sdlMsgVersion.patchVersion.unsignedIntegerValue;

    return self;
}

+ (instancetype)versionWithSDLMsgVersion:(SDLMsgVersion *)sdlMsgVersion {
    return [[self alloc] initWithSDLMsgVersion:sdlMsgVersion];
}

#pragma mark - Setters / Getters

- (NSString *)stringVersion {
    return [NSString stringWithFormat:@"%lu.%lu.%lu", (unsigned long)_major, (unsigned long)_minor, (unsigned long)_patch];
}

#pragma mark - Helper functions

- (NSComparisonResult)compare:(SDLVersion *)otherVersion {
    if (self.major > otherVersion.major) {
        return NSOrderedDescending;
    } else if ((self.major == otherVersion.major) && (self.minor > otherVersion.minor)) {
        return NSOrderedDescending;
    } else if ((self.major == otherVersion.major) && (self.minor == otherVersion.minor) && (self.patch > otherVersion.patch)) {
        return NSOrderedDescending;
    } else if ((self.major == otherVersion.major) && (self.minor == otherVersion.minor) && (self.patch == otherVersion.patch)) {
        return NSOrderedSame;
    }

    return NSOrderedAscending;
}

- (BOOL)isLessThanVersion:(SDLVersion *)otherVersion {
    return ([self compare:otherVersion] == NSOrderedAscending);
}

- (BOOL)isEqualToVersion:(SDLVersion *)otherVersion {
    return ([self compare:otherVersion] == NSOrderedSame);
}

- (BOOL)isGreaterThanVersion:(SDLVersion *)otherVersion {
    return ([self compare:otherVersion] == NSOrderedDescending);
}

- (BOOL)isGreaterThanOrEqualToVersion:(SDLVersion *)otherVersion {
    return ([self isGreaterThanVersion:otherVersion] || [self isEqualToVersion:otherVersion]);
}

- (BOOL)isLessThanOrEqualToVersion:(SDLVersion *)otherVersion {
    return ([self isLessThanVersion:otherVersion] || [self isEqualToVersion:otherVersion]);
}

#pragma mark - NSObject overrides

- (BOOL)isEqual:(id)object {
    if (object == nil) { return NO; }
    if (![object isMemberOfClass:self.class]) { return NO; }

    SDLVersion *otherVersion = (SDLVersion *)object;

    return [self isEqualToVersion:otherVersion];
}

- (NSString *)description {
    return self.stringVersion;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLVersion *new = [[SDLVersion allocWithZone:zone] initWithMajor:_major minor:_minor patch:_patch];
    return new;
}

@end

NS_ASSUME_NONNULL_END
