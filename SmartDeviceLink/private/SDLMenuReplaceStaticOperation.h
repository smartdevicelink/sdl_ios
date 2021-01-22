//
//  SDLMenuReplaceStaticOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/20/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"

@protocol SDLConnectionManagerType;

@class SDLFileManager;
@class SDLMenuCell;
@class SDLMenuConfiguration;
@class SDLWindowCapability;

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuReplaceStaticOperation : SDLAsynchronousOperation

@property (strong, nonatomic) SDLWindowCapability *windowCapability;
@property (strong, nonatomic) SDLMenuConfiguration *menuConfiguration;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability menuConfiguration:(SDLMenuConfiguration *)menuConfiguration currentMenu:(NSArray<SDLMenuCell *> *)currentMenu updatedMenu:(NSArray<SDLMenuCell *> *)updatedMenu;

@end

NS_ASSUME_NONNULL_END
