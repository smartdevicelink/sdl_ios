//
//  SDLSoftButtonTransitionOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonTransitionOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonTransitionOperation ()

@property (strong, nonatomic) SDLSoftButtonCapabilities *softButtonCapabilities;
@property (strong, nonatomic) NSArray<SDLSoftButtonObject *> *softButtons;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLSoftButtonTransitionOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager capabilities:(SDLSoftButtonCapabilities *)capabilities softButtons:(NSArray<SDLSoftButtonObject *> *)softButtons mainField1:(NSString *)mainField1 {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _softButtonCapabilities = capabilities;
    _softButtons = softButtons;
    _mainField1 = mainField1;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_sendNewSoftButtons];
}

- (void)sdl_sendNewSoftButtons {
    SDLShow *newShow = [[SDLShow alloc] init];
    newShow.mainField1 = self.mainField1;
    newShow.softButtons = [self sdl_currentStateSoftButtonsForObjects:self.softButtons];

    [self.connectionManager sendConnectionRequest:newShow withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Failed to transition soft button to new state. Error: %@, Response: %@", error, response);
            self.internalError = error;
        }

        [self finishOperation];
    }];
}

- (NSArray<SDLSoftButton *> *)sdl_currentStateSoftButtonsForObjects:(NSArray<SDLSoftButtonObject *> *)objects {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:objects.count];
    for (SDLSoftButtonObject *button in objects) {
        [softButtons addObject:button.currentStateSoftButton];
    }

    return [softButtons copy];
}

#pragma mark - Property Overrides

- (nullable NSString *)name {
    return @"com.sdl.softbuttonmanager.transition";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
