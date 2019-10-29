//
//  SDLChoiceSetDelegate.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLTriggerSource.h"

@class SDLChoiceCell;
@class SDLChoiceSet;

NS_ASSUME_NONNULL_BEGIN

/// Delegate methods in the SDLChoiceSet
@protocol SDLChoiceSetDelegate <NSObject>

/// Delegate method called after a choice set item was selected
/// @param choiceSet the choice set displayed
/// @param choice the item selected
/// @param source the trigger source
/// @param rowIndex the row of the selected choice
- (void)choiceSet:(SDLChoiceSet *)choiceSet didSelectChoice:(SDLChoiceCell *)choice withSource:(SDLTriggerSource)source atRowIndex:(NSUInteger)rowIndex;

/// Delegate method called on an error
/// @param choiceSet the choice set displayed
/// @param error the item selected
- (void)choiceSet:(SDLChoiceSet *)choiceSet didReceiveError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
