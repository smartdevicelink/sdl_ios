//
//  SDLSoftButtonReplaceOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"

@class SDLSoftButtonCapabilities;
@class SDLFileManager;
@class SDLSoftButtonObject;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is an operation that takes a set of soft buttons and replaces the old set of soft buttons with the new set based on the capabilities available on the system. This operation will handle sending placeholder soft buttons with only text (if possible), uploading the initial state images, sending the initial state soft buttons with those images, and then uploading the other state images.
 */
@interface SDLSoftButtonReplaceOperation : SDLAsynchronousOperation

/**
 The primary text field on the system template. This is necessary to HAX a workaround for Sync 3.
 */
@property (strong, nonatomic) NSString *mainField1;

/**
 Initialize the replace operation

 @param connectionManager The manager that will send the resultant RPCs
 @param fileManager The file manager that will handle uploading any images
 @param capabilities The capabilites of the soft buttons on the current template
 @param softButtonObjects The soft buttons that should be sent
 @param mainField1 The primary text field of the system template
 @return The operation
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager capabilities:(nullable SDLSoftButtonCapabilities *)capabilities softButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects mainField1:(NSString *)mainField1;

@end

NS_ASSUME_NONNULL_END
