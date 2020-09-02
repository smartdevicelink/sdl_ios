//
//  SDLLogFileModule.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogFileModule.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLLogFileModule

- (instancetype)init {
    NSAssert(NO, @"%s not allowed", __PRETTY_FUNCTION__);
    return nil;
}

- (instancetype)initWithName:(NSString *)name files:(NSSet<NSString *> *)files level:(SDLLogLevel)level {
    self = [super init];
    if (!self) { return nil; }

    _name = name;
    _files = files;
    _logLevel = level;

    return self;
}

- (instancetype)initWithName:(NSString *)name files:(NSSet<NSString *> *)files {
    return [self initWithName:name files:files level:SDLLogLevelDefault];
}

+ (instancetype)moduleWithName:(NSString *)name files:(NSSet<NSString *> *)files {
    return [[self alloc] initWithName:name files:files];
}

- (BOOL)containsFile:(NSString *)fileName {
    return [self.files containsObject:fileName];
}


#pragma mark - NSObject

- (NSUInteger)hash {
    return self.name.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:self.class]) {
        return NO;
    }

    return [self isEqualToModule:(SDLLogFileModule *)object];
}

- (BOOL)isEqualToModule:(SDLLogFileModule *)module {
    return [self.name isEqualToString:module.name];
}

@end

NS_ASSUME_NONNULL_END
