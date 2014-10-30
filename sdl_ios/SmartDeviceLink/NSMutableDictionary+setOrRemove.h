//
//  NSMutableDictionary+setOrRemove.h
//  SmartDeviceLink
//
//  Created by Justin Dickow on 10/29/14.
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (setOrRemove)
- (void)setOrRemoveObject:(id)object forKey:(id <NSCopying>)key;
@end
