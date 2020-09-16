//
//  NSDictionary+SafeRemove.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/21/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary <KeyType, ObjectType> (SafeRemove)

/**
 *  Safely attempt to remove a key/object pair by no-oping if they don't exist in the Mutable Dictionary instead of throwing an exception
 *
 *  @param aKey The key to attempt removal of
 *
 *  @return Whether or not the key/object pair existed to remove.
 */
- (BOOL)safeRemoveObjectForKey : (KeyType)aKey;

@end

@interface NSMapTable <KeyType, ObjectType> (SafeRemove)

/**
 *  Safely attempt to remove a key/object pair by no-oping if they don't exist in the MapTable instead of throwing an exception
 *
 *  @param aKey The key to attempt removal of
 *
 *  @return Whether or not the key/object pair existed to remove.
 */
- (BOOL)safeRemoveObjectForKey : (KeyType)aKey;

@end
