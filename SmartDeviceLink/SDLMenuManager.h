//
//  SDLMenuManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLMenuCell;
@class SDLVoiceCommand;

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLMenuUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLMenuManager : NSObject

@property (copy, nonatomic) NSArray<SDLMenuCell *> *menuCells;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *voiceCommands;

@end
