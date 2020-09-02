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

@property (copy, nonatomic, readwrite) NSURL *inputFileURL;
@property (copy, nonatomic, readwrite) NSURL *outputFileURL;
@property (copy, nonatomic, readwrite) NSData *data;
@property (copy, nonatomic, readwrite) NSString *name;

@end

@implementation SDLAudioFile

- (instancetype)initWithInputFileURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputURL estimatedDuration:(UInt32)duration {
    self = [super init];
    if (!self) { return nil; }

    _inputFileURL = inputURL;
    _outputFileURL = outputURL;
    _estimatedDuration = duration;

    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (!self) { return nil; }

    _data = data;

    return self;
}

- (NSData *)data {
    if (_data.length == 0) {
        return [NSData dataWithContentsOfURL:_outputFileURL];
    }

    return _data;
}

/**
 Gets the size of the data. The data may be stored on disk or it may already be in the application's memory.

 @return The size of the data.
 */
- (unsigned long long)fileSize {
    if (_outputFileURL != nil) {
        // Data in file
        NSString *path = [_outputFileURL path];
        return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    } else if (_data) {
        // Data in memory
        return _data.length;
    }
    return 0;
}

@end

NS_ASSUME_NONNULL_END
