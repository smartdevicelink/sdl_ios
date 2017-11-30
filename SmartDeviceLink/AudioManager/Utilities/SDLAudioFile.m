//
//  SDLAudioFile.m
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLAudioFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioFile ()

@property (copy, nonatomic, readwrite, nullable) NSURL *fileURL;
@property (copy, nonatomic, readwrite) NSData *data;
@property (copy, nonatomic, readwrite) NSString *name;

@end

@implementation SDLAudioFile

- (instancetype)initWithFileURL:(NSURL *)url estimatedDuration:(UInt32)duration {
    self = [super init];
    if (!self) { return nil; }

    _fileURL = url;
    _estimatedDuration = duration;

    return self;
}

- (NSData *)data {
    if (_data.length == 0 && _fileURL != nil) {
        return [NSData dataWithContentsOfURL:_fileURL];
    }

    return _data;
}

/**
 Gets the size of the data. The data may be stored on disk or it may already be in the application's memory.

 @return The size of the data.
 */
- (unsigned long long)fileSize {
    if (_fileURL) {
        // Data in file
        NSString *path = [_fileURL path];
        return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    } else if (_data) {
        // Data in memory
        return _data.length;
    }
    return 0;
}

@end

NS_ASSUME_NONNULL_END
