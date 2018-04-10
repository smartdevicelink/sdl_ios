//
//  SDLMenuManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFileManager;
@class SDLMenuCell;
@class SDLVoiceCommand;

@protocol SDLConnectionManagerType;

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLMenuUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLMenuManager : NSObject

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

@property (copy, nonatomic) NSArray<SDLMenuCell *> *menuCells;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *voiceCommands;

@end
