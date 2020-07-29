//
//  TestSubscribeButtonObserver.m
//  SmartDeviceLink
//
//  Created by Nicole on 6/22/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "TestSubscribeButtonObserver.h"

@implementation TestSubscribeButtonObserver

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _selectorCalledCount = 0;
    _buttonNamesReceived = [NSMutableArray<SDLButtonName> array];
    _buttonErrorsReceived = [NSMutableArray<NSError *> array];
    _buttonEventsReceived = [NSMutableArray<SDLOnButtonEvent *> array];
    _buttonPressesReceived = [NSMutableArray<SDLOnButtonPress *> array];
    
    return self;
}

- (void)buttonPressEvent {
    [self sdl_saveButtonName:nil buttonError:nil buttonPress:nil buttonEvent:nil];
}

- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName {
    [self sdl_saveButtonName:buttonName buttonError:nil buttonPress:nil buttonEvent:nil];
}

- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error {
    [self sdl_saveButtonName:buttonName buttonError:error buttonPress:nil buttonEvent:nil];
}

- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress {
    [self sdl_saveButtonName:buttonName buttonError:error buttonPress:buttonPress buttonEvent:nil];
}

- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress buttonEvent:(SDLOnButtonEvent *)buttonEvent {
    [self sdl_saveButtonName:buttonName buttonError:error buttonPress:buttonPress buttonEvent:buttonEvent];
}

- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress buttonEvent:(SDLOnButtonEvent *)buttonEvent extraParameter:(BOOL)extraParameter {
    [self sdl_saveButtonName:buttonName buttonError:error buttonPress:buttonPress buttonEvent:buttonEvent];
}

- (void)sdl_saveButtonName:(nullable SDLButtonName)buttonName buttonError:(nullable NSError *)buttonError buttonPress:(nullable SDLOnButtonPress *)buttonPress buttonEvent:(nullable SDLOnButtonEvent *)buttonEvent {
    self.selectorCalledCount++;

    if (buttonName != nil) {
        [self.buttonNamesReceived addObject:buttonName];
    }

    if (buttonError != nil) {
        [self.buttonErrorsReceived addObject:buttonError];
    }

    if (buttonPress != nil) {
        [self.buttonPressesReceived addObject:buttonPress];
    }

    if (buttonEvent != nil) {
        [self.buttonEventsReceived addObject:buttonEvent];
    }
}

@end
