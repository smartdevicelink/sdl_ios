//
//  SDLFile.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFile ()

@property (copy, nonatomic) NSString *filePath;

@end


@implementation SDLFile

#pragma mark - Lifecycle

- (instancetype)initWithFileAtPath:(NSString *)path {
    return [self initWithFileAtPath:path name:[[NSFileManager defaultManager] displayNameAtPath:path] persistent:NO];
}

- (instancetype)initWithPersistentFileAtPath:(NSString *)path name:(NSString *)name {
    return [self initWithFileAtPath:path name:name persistent:YES];
}

#pragma mark Private

- (instancetype)initWithFileAtPath:(NSString *)path name:(NSString *)name persistent:(BOOL)persistent {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    BOOL pathExists = [[NSFileManager defaultManager] isReadableFileAtPath:path];
    if (!pathExists) {
        return nil;
    }
    
    _filePath = path;
    _name = name;
    _persistent = persistent;
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
