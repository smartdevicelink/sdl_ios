//
//  SDLSoftButtonObject.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonObject.h"

#import "SDLError.h"
#import "SDLLogMacros.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonManager.h"
#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonManager()

- (void)sdl_transitionSoftButton:(SDLSoftButtonObject *)softButton;

@end

@interface SDLSoftButtonObject()

@property (assign, nonatomic) NSUInteger buttonId;
@property (strong, nonatomic) NSString *currentStateName;
@property (weak, nonatomic) SDLSoftButtonManager *manager;

@end

@implementation SDLSoftButtonObject

- (instancetype)initWithName:(NSString *)name states:(NSArray<SDLSoftButtonState *> *)states initialStateName:(NSString *)initialStateName handler:(nullable SDLRPCButtonNotificationHandler)eventHandler {
    self = [super init];
    if (!self) { return nil; }

    // Make sure there aren't two states with the same name
    if ([self sdl_hasTwoStatesOfSameName:states]) {
        return nil;
    }

    _name = name;
    _states = states;
    _currentStateName = initialStateName;
    _eventHandler = eventHandler;

    return self;
}

- (instancetype)initWithName:(NSString *)name state:(SDLSoftButtonState *)state handler:(nullable SDLRPCButtonNotificationHandler)eventHandler {
    return [self initWithName:name states:@[state] initialStateName:state.name handler:eventHandler];
}

- (instancetype)initWithName:(NSString *)name text:(nullable NSString *)text artwork:(nullable SDLArtwork *)artwork handler:(nullable SDLRPCButtonNotificationHandler)eventHandler {
    SDLSoftButtonState *implicitState = [[SDLSoftButtonState alloc] initWithStateName:name text:text artwork:artwork];
    return [self initWithName:name state:implicitState handler:eventHandler];
}

- (BOOL)transitionToStateNamed:(NSString *)stateName {
    if ([self stateWithName:stateName] == nil) {
        SDLLogE(@"Attempted to transition to state: %@ on soft button: %@ but no state with that name was found", stateName, self.name);
        return NO;
    }

    if (self.states.count == 1) {
        SDLLogW(@"There's only one state, so no transitioning is possible!");
        return NO;
    }

    SDLLogD(@"Transitioning button %@ to state %@", self.name, stateName);
    self.currentStateName = stateName;
    [self.manager sdl_transitionSoftButton:self];

    return YES;
}

- (void)transitionToNextState {
    NSString *nextStateName = nil;
    for (NSUInteger i = 0; i < self.states.count; i++) {
        if ([self.states[i].name isEqualToString:self.currentStateName]) {
            NSUInteger nextStateNumber = (i == self.states.count - 1) ? 0 : (i + 1);
            nextStateName = self.states[nextStateNumber].name;
            break;
        }
    }

    if (nextStateName == nil) {
        return;
    }
    
    [self transitionToStateNamed:nextStateName];
}

- (SDLSoftButtonState *)currentState {
    SDLSoftButtonState *state = [self stateWithName:self.currentStateName];

    if (state == nil) {
        @throw [NSException sdl_invalidSoftButtonStateException];
    } else {
        return state;
    }
}

- (SDLSoftButton *)currentStateSoftButton {
    SDLSoftButton *button = self.currentState.softButton;
    button.softButtonID = @(self.buttonId);
    button.handler = self.eventHandler;

    return button;
}

- (nullable SDLSoftButtonState *)stateWithName:(NSString *)stateName {
    for (SDLSoftButtonState *state in self.states) {
        if ([state.name isEqualToString:stateName]) {
            return state;
        }
    }

    return nil;
}

- (BOOL)sdl_hasTwoStatesOfSameName:(NSArray<SDLSoftButtonState *> *)states {
    for (NSUInteger i = 0; i < states.count; i++) {
        NSString *stateName = states[i].name;
        for (NSUInteger j = (i + 1); j < states.count; j++) {
            if ([states[j].name isEqualToString:stateName]) {
                return YES;
            }
        }
    }

    return NO;
}

- (NSString *)description {
    NSMutableArray<NSString *> *allStateNames = [NSMutableArray array];
    for (SDLSoftButtonState *state in self.states) {
        [allStateNames addObject:state.name];
    }

    return [NSString stringWithFormat:@"Name: %@, Current State: %@, All States: %@", self.name, self.currentStateName, allStateNames];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Name: %@, Current State: %@, All States: %@", self.name, self.currentState, self.states];
}

@end

NS_ASSUME_NONNULL_END
