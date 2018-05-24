//
//  SDLPresentKeyboardOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPresentKeyboardOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLPerformInteraction.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentKeyboardOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) id<SDLKeyboardDelegate> keyboardDelegate;
@property (copy, nonatomic) NSString *initialText;

@property (strong, nonatomic) SDLPerformInteraction *performInteraction;

@end

@implementation SDLPresentKeyboardOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager initialText:(NSString *)initialText keyboardDelegate:(id<SDLKeyboardDelegate>)keyboardDelegate {
    self = [super init];
    if (!self) { return self; }

    _connectionManager = connectionManager;
    _initialText = initialText;
    _keyboardDelegate = keyboardDelegate;

    return self;
}

- (void)start {
    [super start];

    [self sdl_presentKeyboard];
}

- (void)sdl_presentKeyboard {
    [self.connectionManager sendConnectionRequest:self.performInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        // TODO
        [self finishOperation];
    }];
}


#pragma mark - Private Getters / Setters

- (SDLPerformInteraction *)performInteraction {
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.initialText = self.initialText;
    performInteraction.interactionMode = SDLInteractionModeManualOnly;
    performInteraction.interactionChoiceSetIDList = @[@0];
    performInteraction.interactionLayout = SDLLayoutModeKeyboard;

    return performInteraction;
}

@end

NS_ASSUME_NONNULL_END
