//
//  NSMapTable+Subscripting.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Implement subscripting methods for NSMapTable to allow for easily pushing and pulling objects.
 */
@interface NSMapTable<KeyType, ObjectType> (Subscripting)

- (void)setObject:(nullable ObjectType)obj forKeyedSubscript:(KeyType<NSCopying>)key;
- (nullable ObjectType)objectForKeyedSubscript:(KeyType<NSCopying>)key;
@property (readonly, copy) NSArray<KeyType> *allKeys;

@end

NS_ASSUME_NONNULL_END
