//
//  SDLAudioFile.h
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <SmartDeviceLink/SmartDeviceLink.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioFile : NSObject

@property (copy, nonatomic, readonly) NSURL *fileURL;

/**
 In seconds. UINT32_MAX if unknown.
 */
@property (assign, nonatomic) UInt32 estimatedDuration;

@property (copy, nonatomic, readonly) NSData *data;

@property (assign, nonatomic, readonly) unsigned long long fileSize;

- (instancetype)initWithFileURL:(NSURL *)url estimatedDuration:(UInt32)duration;

@end

NS_ASSUME_NONNULL_END
