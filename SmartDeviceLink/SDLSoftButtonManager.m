//
//  SDLSoftButtonManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonManager.h"

#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

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

- (BOOL)updateButtonNamed:(NSString *)buttonName replacingCurrentStateWithState:(SDLSoftButtonState *)state {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", buttonName];
    NSArray<SDLSoftButtonObject *> *buttons = [self.softButtons filteredArrayUsingPredicate:predicate];
    if (buttons.count == 0) {
        return NO;
    }

    NSAssert(buttons.count == 1, @"Multiple SDLSoftButtonObjects are named the same thing, this should have been checked for");
    SDLSoftButtonObject *button = buttons.firstObject;
    [button transitionToState:state.name];

    if (_isBatchingUpdates) {
        return YES;
    }

    // TODO: Else send the update

    return YES;
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

    // TODO: Check to make sure no two soft buttons have the same name
}

@end

NS_ASSUME_NONNULL_END
