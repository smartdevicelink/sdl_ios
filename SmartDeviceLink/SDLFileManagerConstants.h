//
//  SDLFileManagerConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLFileManagerUploadCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);
typedef void (^SDLFileManagerDeleteCompletion)(BOOL success, NSUInteger bytesAvailable, NSError * __nullable error);
typedef void (^SDLFileManagerListFilesCompletion)(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> *fileNames, NSError * __nullable error);

@interface SDLFileManagerConstants : NSObject

@end

NS_ASSUME_NONNULL_END