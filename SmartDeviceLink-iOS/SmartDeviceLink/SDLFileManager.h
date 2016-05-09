//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLConnectionManagerType.h"
#import "SDLStateMachine.h"

@class SDLFile;


NS_ASSUME_NONNULL_BEGIN

extern NSString *const SDLFileManagerStateNotConnected;
extern NSString *const SDLFileManagerStateFetchingInitialList;
extern NSString *const SDLFileManagerStateCheckingQueue;
extern NSString *const SDLFileManagerStateUploading;
extern NSString *const SDLFileManagerStateIdle;


typedef NSString SDLFileName;

typedef void (^SDLFileManagerDeleteCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);
typedef void (^SDLFileManagerUploadCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);


@interface SDLFileManager : NSObject

@property (copy, nonatomic, readonly) NSSet<SDLFileName *> *remoteFileNames;
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;
@property (copy, nonatomic, readonly) SDLState *currentState;

@property (assign, nonatomic) BOOL allowOverwrite;

/**
 *  Creates a new file manager where the connection manager is [SDLManager sharedManager], and there are no initial files.
 *
 *  @return An instance of SDLFileManager
 */
- (instancetype)init;

/**
 *  Creates a new file manager with a specified connection manager
 *
 *  @param manager A connection manager to use to forward on RPCs
 *  @param initialFiles Files that should be available before the file manager is considered "ready"
 *
 *  @return An instance of SDLFileManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager initialFiles:(NSArray<SDLFile *> *)initialFiles NS_DESIGNATED_INITIALIZER;

/**
 *  Delete a file stored on the remote system
 *
 *  @param name       The name of the remote file. It should be a name currently stored in remoteFileNames
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletion)completion;

/**
 *  Upload a file to the remote file system. If a file with the [SDLFile name] already exists, this will overwrite that file. If you do not want that to happen, check remoteFileNames before uploading, or change allowOverwrite to NO.
 *
 *  @param file       An SDLFile that contains metadata about the file to be sent
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion;

/**
 *  Upload a file to the remote file system. If a file with the [SDLFile name] already exists, and allowOverwrite is NO, this method will still overwrite the file.
 *
 *  @param file       An SDLFile that contains metadata about the file to be sent
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)forceUploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion;

@end

NS_ASSUME_NONNULL_END
