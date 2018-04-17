//
//  SDLMenuCell.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLArtwork;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLMenuCellSelectionHandler)(void);

@interface SDLMenuCell : NSObject

@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly, nullable) SDLArtwork *icon;
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *voiceCommands;
@property (copy, nonatomic, readonly, nullable) SDLMenuCellSelectionHandler handler;

// Note that if this is non-nil, the icon and handler will be ignored.
@property (copy, nonatomic, readonly, nullable) NSArray<SDLMenuCell *> *subCells;

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler;
- (instancetype)initWithTitle:(NSString *)title subCells:(NSArray<SDLMenuCell *> *)subCells;

@end

NS_ASSUME_NONNULL_END
