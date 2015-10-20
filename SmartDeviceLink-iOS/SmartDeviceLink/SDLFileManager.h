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

typedef void (^SDLFileManagerDeleteCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);
typedef void (^SDLFileManagerUploadCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);

@interface SDLFileManager : NSObject

@property (copy, nonatomic, readonly) NSArray<SDLFileName *> *remoteFiles;
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;

// TODO: These are currently untestable as they interact directly with the SDLManager singleton. A protocol property or dependency would be much better (initWithManager: / initWithConnection:) something like that.
- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(SDLFileManagerDeleteCompletion)completion;
- (void)uploadFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completion;

@end

NS_ASSUME_NONNULL_END
