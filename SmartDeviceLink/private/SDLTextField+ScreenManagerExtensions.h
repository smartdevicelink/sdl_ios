//
//  SDLTextField+ScreenManagerExtensions.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/20/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTextField (ScreenManagerExtensions)

+ (NSArray<SDLTextField *> *)allTextFields;

@end

NS_ASSUME_NONNULL_END
