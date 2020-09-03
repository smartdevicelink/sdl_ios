//
//  SDLPCMAudioConverter.h
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SDLErrorDomainPCMAudioStreamConverter;

@interface SDLPCMAudioConverter : NSObject

@property (assign, nonatomic, readonly) UInt32 estimatedDuration;

- (nullable instancetype)initWithFileURL:(NSURL *)fileURL;

/**
 Synchronously convert the file that it was init'd with, returning an error if it fails and the NSURL of the new file if it succeeds

 @param error An error object containing the OSStatus if it failed to convert
 @return The NSURL of the newly converted file
 */
- (nullable NSURL *)convertFileWithError:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
