//
//  NSMapTable+Subscripting.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMapTable (Subscripting)

- (void)setObject:(nullable id)anObject forKeyedSubscript:(nonnull id<NSCopying>)key;
- (nullable id)objectForKeyedSubscript:(nonnull id<NSCopying>)key;

@end
