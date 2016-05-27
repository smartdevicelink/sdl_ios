//
//  NSMapTable+Subscripting.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMapTable (Subscripting)

- (void)setObject:(nullable id)anObject forKeyedSubscript:(id<NSCopying>)key;
- (nullable id)objectForKeyedSubscript:(id<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END