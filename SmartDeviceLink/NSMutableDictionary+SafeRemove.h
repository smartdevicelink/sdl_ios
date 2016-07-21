//
//  NSDictionary+SafeRemove.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/21/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary <KeyType, ObjectType> (SafeRemove)

- (BOOL)safeRemoveObjectForKey:(KeyType)aKey;

@end

@interface NSMapTable <KeyType, ObjectType> (SafeRemove)

- (BOOL)safeRemoveObjectForKey:(KeyType)aKey;

@end
