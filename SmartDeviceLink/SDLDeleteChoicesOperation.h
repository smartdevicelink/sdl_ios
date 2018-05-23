//
//  SDLDeleteChoicesOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"

@class SDLChoiceCell;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLChoiceSetManagerDeleteCompletionHandler)(NSError *__nullable error);

@interface SDLDeleteChoicesOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager cellsToDelete:(NSSet<SDLChoiceCell *> *)cells completionHandler:(nullable SDLChoiceSetManagerDeleteCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
