//
//  SDLDeleteFileOperation.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLFileManagerConstants.h"

@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFileOperation : NSOperation

- (instancetype)initWithFileName:(NSString *)fileName connectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerDeleteCompletion)completionHandler;

@end

NS_ASSUME_NONNULL_END