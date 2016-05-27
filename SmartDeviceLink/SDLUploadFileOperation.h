//
//  SDLUploadFileOperation.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLFileManagerConstants.h"

@protocol SDLConnectionManagerType;
@class SDLFileWrapper;


NS_ASSUME_NONNULL_BEGIN


@interface SDLUploadFileOperation : NSOperation

- (instancetype)initWithFile:(SDLFileWrapper *)file connectionManager:(id<SDLConnectionManagerType>)connectionManager;

@end

NS_ASSUME_NONNULL_END