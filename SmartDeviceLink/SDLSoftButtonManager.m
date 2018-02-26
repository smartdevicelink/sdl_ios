//
//  SDLSoftButtonManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@end

@implementation SDLSoftButtonManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;

    return self;
}

- (void)updateButtonNamed:(NSString *)buttonName replacingCurrentStateWithState:(SDLSoftButtonState *)state {
    
}

- (void)beginUpdates {
    _isBatchingUpdates = YES;
}

- (void)endUpdatesWithCompletionHandler:(SDLSoftButtonUpdateCompletionHandler)handler {
    _isBatchingUpdates = NO;
}

- (void)setSoftButtons:(NSArray<SDLSoftButtonObject *> *)softButtons {
    // TODO: Update soft buttons
    _isBatchingUpdates = NO;
}

@end

NS_ASSUME_NONNULL_END
