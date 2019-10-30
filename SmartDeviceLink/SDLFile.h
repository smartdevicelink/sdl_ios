//
//  SDLFile.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLFileType.h"


NS_ASSUME_NONNULL_BEGIN

/// Crates an SDLFile from a file
@interface SDLFile : NSObject <NSCopying>

/**
 *  Whether or not the file should persist on disk between car ignition cycles.
 */
@property (assign, nonatomic, readonly, getter=isPersistent) BOOL persistent;

/**
 *  Whether or not the file should overwrite an existing file on the remote disk with the same name.
 */
@property (assign, nonatomic) BOOL overwrite;

/**
 *  The name the file should be stored under on the remote disk. This is how the file will be referenced in all later calls.
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 *  The url the local file is stored at while waiting to push it to the remote system. If the data has not been passed to the file URL, this will be nil.
 */
@property (copy, nonatomic, readonly, nullable) NSURL *fileURL;

/**
 *  The binary data of the SDLFile. If initialized with data, this will be a relatively quick call, but if initialized with a file URL, this is a rather expensive call the first time. The data will be cached in RAM after the first call.
 */
@property (copy, nonatomic, readonly) NSData *data;

/**
 *  The size of the binary data of the SDLFile.
 */
@property (nonatomic, readonly) unsigned long long fileSize;

/**
 *  The system will attempt to determine the type of file that you have passed in. It will default to BINARY if it does not recognize the file type or the file type is not supported by SDL.
 */
@property (strong, nonatomic, readonly) SDLFileType fileType;

/**
 * A stream to pull binary data from a SDLFile. The stream only pulls required data from the file on disk or in memory. This reduces memory usage while uploading a large file to the remote system as each chunk of data can be released immediately after it is uploaded.
 */
@property (nonatomic, readonly) NSInputStream *inputStream;

/**
 Describes whether or not this file is represented by static icon data. The head unit will present its representation of the static icon concept when sent this data.

 A file that represents a static icon may not be uploaded via the File Manager. It must be set using the Screen Manager.

 Support for this feature may vary by system, but it will generally be more supported in soft buttons and menus.
 */
@property (assign, nonatomic, readonly) BOOL isStaticIcon;

/// Initializer unavailable
- (instancetype)init NS_UNAVAILABLE;

/**
 *  The designated initializer for an SDL File. The only major property that is not set using this is "overwrite", which defaults to NO.
 *
 *  @param url        The file URL pointing to the local data that will be pushed to the remote system.
 *  @param name       The name that the file will be stored under on the remote system and how it will be referenced from the local system. The max file name length may vary based on remote filesystem limitations.
 *  @param persistent Whether or not the file will persist between ignition cycles.
 *
 *  @return An SDLFile object.
 */
- (instancetype)initWithFileURL:(NSURL *)url name:(NSString *)name persistent:(BOOL)persistent NS_DESIGNATED_INITIALIZER;

/**
 *  Create an SDL file using a local file URL.
 *
 *  This is a persistent file, it will be persisted through sessions / ignition cycles. You will only have a limited space for all files, so be sure to only persist files that are required for all or most sessions. For example, menu artwork should be persistent.
 *
 *  Ephemeral files should be created using ephemeralFileAtURL:name:
 *
 *  @warning If this is not a readable file, this will return nil
 *
 *  @param url The url to the file that should be uploaded.
 *  @param name The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote filesystem limitations.
 *
 *  @return An instance of this class, or nil if a readable file at the path could not be found.
 */
+ (instancetype)persistentFileAtFileURL:(NSURL *)url name:(NSString *)name NS_SWIFT_UNAVAILABLE("Use the standard initializer and set persistant to true");

/**
 *  Create an SDL file using a local file URL.
 *
 *  This is an ephemeral file, it will not be persisted through sessions / ignition cycles. Any files that you do not *know* you will use in future sessions should be created through this method. For example, album / artist artwork should be ephemeral.
 *
 *  Persistent files should be created using persistentFileAtURL:name:
 *
 *  @warning If this is not a readable file, this will return nil
 *
 *  @param url The url to the file on disk that will be uploaded
 *  @param name The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *
 *  @return An instance of this class, or nil if a readable file at the url could not be found.
 */
+ (instancetype)fileAtFileURL:(NSURL *)url name:(NSString *)name;

/**
 *  Create an SDL file using raw data. It is strongly preferred to pass a file URL instead of data, as it is currently held in memory until the file is sent.
 *
 *  @param data         The raw data to be used for the file
 *  @param name         The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *  @param extension    The file extension. For example "png". Currently supported file extensions are: "bmp", "jpg", "jpeg", "png", "wav", "mp3", "aac", "json". All others will be sent as binary files.
 *  @param persistent   Whether or not the remote file with this data should be persistent
 *
 *  @return An instance of this class
 */
- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension persistent:(BOOL)persistent NS_DESIGNATED_INITIALIZER;

/**
 *  Create an SDL file using raw data. It is strongly preferred to pass a file URL instead of data, as it is currently held in memory until the file is sent.
 *
 *  This is a persistent file, it will be persisted through sessions / ignition cycles. You will only have a limited space for all files, so be sure to only persist files that are required for all or most sessions. For example, menu artwork should be persistent.
 *
 *  @param data         The raw data to be used for the file
 *  @param name         The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *  @param extension    The file extension. For example "png". Currently supported file extensions are: "bmp", "jpg", "jpeg", "png", "wav", "mp3", "aac", "json". All others will be sent as binary files.
 *
 *  @return An instance of this class
 */
+ (instancetype)persistentFileWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension NS_SWIFT_UNAVAILABLE("Use the standard initializer and set persistant to true");

/**
 *  Create an SDL file using raw data. It is strongly preferred to pass a file URL instead of data, as it is currently held in memory until the file is sent.
 *
 *  This is an ephemeral file, it will not be persisted through sessions / ignition cycles. Any files that you do not *know* you will use in future sessions should be created through this method. For example, album / artist artwork should be ephemeral.
 *
 *  @param data         The raw data to be used for the file
 *  @param name         The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *  @param extension    The file extension. For example "png". Currently supported file extensions are: "bmp", "jpg", "jpeg", "png", "wav", "mp3", "aac", "json". All others will be sent as binary files.
 *
 *  @return An instance of this class
 */
+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension;

@end

NS_ASSUME_NONNULL_END
