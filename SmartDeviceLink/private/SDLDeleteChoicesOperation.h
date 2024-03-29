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

@interface SDLDeleteChoicesOperation : SDLAsynchronousOperation

typedef void(^SDLDeleteChoicesCompletionHandler)(NSSet<SDLChoiceCell *> *updatedLoadedCells, NSError *_Nullable error);

/// The cells that are loaded on the head unit
@property (strong, nonatomic) NSSet<SDLChoiceCell *> *loadedCells;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager cellsToDelete:(NSSet<SDLChoiceCell *> *)cellsToDelete loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells completionHandler:(SDLDeleteChoicesCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
