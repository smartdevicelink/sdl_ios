//
//  TextValidator.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextValidator : NSObject

+ (NSString *)validateText:(NSString *)text length:(UInt8)length;

@end

NS_ASSUME_NONNULL_END
