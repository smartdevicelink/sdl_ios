//
//  SDLFile.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFileType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLFile : NSObject

@property (assign, nonatomic, readonly, getter=isPersistent) BOOL persistent;
@property (copy, nonatomic, readonly) NSString *name;

/**
 *  Unless set manually, the system will attempt to determine the type of file that you have passed in.
 */
@property (strong, nonatomic, readonly) SDLFileType *fileType;

/**
 *  Create an SDL file using a local file path. If all that you have is the local file URL, then use [NSURL isFileURL] to be certain it is a file URL. If it is, use [NSURL path] to change it to a path.
 *
 *  The "name" used to reference this file will be created by [NSString lastPathComponent]
 *
 *  This is an ephemeral file, it will not be persisted through sessions / ignition cycles. Any files that you do not *know* you will use in future sessions should be created through this method. For example, album / artist artwork should be ephemeral.
 *
 *  Persistent files should be created using initWithPersistentFileAtPath:name:
 *
 *  @warning If this is not a readable file, this will return nil
 *
 *  @param path The path to the file that should be uploaded
 *
 *  @return An instance of this class, or nil if a readable file at the path could not be found.
 */
- (instancetype)initWithFileAtPath:(NSString *)path;

/**
 *  Create an SDL file using a local file path. If all that you have is the local file URL, then use [NSURL isFileURL] to be certain it is a file URL. If it is, use [NSURL path] to change it to a path.
 *
 *  This is a persistent file, it will be persisted through sessions / ignition cycles. You will only have a limited space for all files, so be sure to only persist files that are required for all or most sessions. For example, menu artwork should be persistent.
 *
 *  Ephemeral files should be created using initWithFileAtPath:
 *
 *  @warning If this is not a readable file, this will return nil
 *
 *  @param path The path to the file that should be uploaded
 *  @param name The name of the file that will be used to reference the file in the future (for example on the remote file system).
 *
 *  @return An instance of this class, or nil if a readable file at the path could not be found.
 */
- (instancetype)initWithPersistentFileAtPath:(NSString *)path name:(NSString *)name;

/**
 *  Create an SDL file using raw data.
 *
 *  @param data     The raw data to be used for the file
 *  @param name     The name of the file that will be used to reference the file in the future (for example on the remote file system).
 *  @param fileType The file type for this file
 *
 *  @return An instance of this class
 */
- (instancetype)initWithData:(NSData *)data name:(NSString *)name type:(SDLFileType *)fileType;

@end

NS_ASSUME_NONNULL_END
