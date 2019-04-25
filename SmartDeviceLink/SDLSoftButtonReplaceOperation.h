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

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonReplaceOperation : SDLAsynchronousOperation

@property (strong, nonatomic) NSString *mainField1;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager capabilities:(SDLSoftButtonCapabilities *)capabilities softButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects mainField1:(NSString *)mainField1;

@end

NS_ASSUME_NONNULL_END
