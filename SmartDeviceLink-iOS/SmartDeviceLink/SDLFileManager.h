//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFile;


NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLFileName;

typedef void (^SDLFileManagerDeleteCompletion)(BOOL success, NSUInteger bytesAvailable, NSError *error);
typedef void (^SDLFileManagerUploadCompletion)(BOOL success, NSUInteger bytesAvailable, NSError *error);

@interface SDLFileManager : NSObject

@property (copy, nonatomic, readonly) NSArray<SDLFileName *> *remoteFiles;
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(SDLFileManagerDeleteCompletion)completion;
- (void)uploadFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completion;

@end

NS_ASSUME_NONNULL_END
