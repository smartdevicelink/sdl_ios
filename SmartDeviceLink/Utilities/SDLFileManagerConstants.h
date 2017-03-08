//
//  SDLFileManagerConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLFileManagerUploadCompletionHandler)(BOOL success, NSUInteger bytesAvailable, NSError *__nullable error);
typedef void (^SDLFileManagerDeleteCompletionHandler)(BOOL success, NSUInteger bytesAvailable, NSError *__nullable error);
typedef void (^SDLFileManagerListFilesCompletionHandler)(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> *fileNames, NSError *__nullable error);

NS_ASSUME_NONNULL_END