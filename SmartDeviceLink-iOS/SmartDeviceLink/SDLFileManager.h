//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLConnectionManager.h"

@class SDLFile;


NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLFileName;

typedef void (^SDLFileManagerDeleteCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);
typedef void (^SDLFileManagerUploadCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);


@interface SDLFileManager : NSObject

@property (copy, nonatomic, readonly) NSArray<SDLFileName *> *remoteFiles;
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;

/**
 *  Creates a new file manager where the connection manager is [SDLManager sharedManager]
 *
 *  @return An instance of SDLFileManager
 */
- (instancetype)init;

/**
 *  Creates a new file manager with a specified connection manager
 *
 *  @param manager A connection manager to use to forward on RPCs
 *
 *  @return An instance of SDLFileManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManager>)manager;

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(SDLFileManagerDeleteCompletion)completion;
- (void)uploadFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completion;

@end

NS_ASSUME_NONNULL_END
