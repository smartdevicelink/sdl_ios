//
//  NSMutableDictionary+setOrRemove.h
//  SmartDeviceLink
//
//  Created by Justin Dickow on 10/29/14.
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SetOrRemove)

/**
 *  Calls setObject:forKey: if the object is not nil, calls removeObjectForKey: if the object is nil
 *
 *  @param object The object to be set or nil if it should be removed
 *  @param key    The key
 */
- (void)setOrRemoveObject:(id)object forKey:(id <NSCopying>)key;
@end
