//
//  SDLVersion.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/19/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLVersion.h"

#import "SDLSyncMsgVersion.h"

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

+ (instancetype)versionWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch {
    return [[self alloc] initWithMajor:major minor:minor patch:patch];
}

- (instancetype)initWithString:(NSString *)versionString {
    self = [super init];
    if (!self) { return nil; }

    NSArray<NSString *> *splitVersions = [versionString componentsSeparatedByString:@"."];
    NSAssert(splitVersions.count == 3, @"Splitting a version string must result in major, minor, and patch. The format must be 'X.X.X'");

    _major = (NSUInteger)splitVersions[0].integerValue;
    _minor = (NSUInteger)splitVersions[1].integerValue;
    _patch = (NSUInteger)splitVersions[2].integerValue;

    return self;
}

+ (instancetype)versionWithString:(NSString *)versionString {
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

@end
