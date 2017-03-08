//
//  SDLFileWrapper.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLFileManagerConstants.h"


@class SDLFile;


NS_ASSUME_NONNULL_BEGIN

@interface SDLFileWrapper : NSObject

@property (strong, nonatomic, readonly) SDLFile *file;
@property (copy, nonatomic, readonly) SDLFileManagerUploadCompletionHandler completionHandler;

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletionHandler)completionHandler;

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END