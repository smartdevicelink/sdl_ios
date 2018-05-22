//
//  SDLScreenManagerDelegate.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SDLScreenManagerErrorType) {
    SDLScreenManagerErrorTypeTextAndGraphic,
    SDLScreenManagerErrorTypeSoftButton,
    SDLScreenManagerErrorTypeMenu,
    SDLScreenManagerErrorTypeChoiceSet
};

@protocol SDLScreenManagerDelegate <NSObject>

- (void)screenManager:(SDLScreenManager *)screenManager didFailToUpdate:(SDLScreenManagerErrorType)type withError:(NSError *)error;

@end
