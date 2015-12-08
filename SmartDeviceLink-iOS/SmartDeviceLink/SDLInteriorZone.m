//
//  SDLInteriorZone.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLInteriorZone.h"

#import "SDLNames.h"


@implementation SDLInteriorZone

- (void)setColumn:(NSNumber *)column {
    if (column != nil) {
        [store setObject:column forKey:NAMES_col];
    } else {
        [store removeObjectForKey:NAMES_col];
    }
}

- (NSNumber *)column {
    return [store objectForKey:NAMES_col];
}

- (void)setRow:(NSNumber *)row {
    if (row != nil) {
        [store setObject:row forKey:NAMES_row];
    } else {
        [store removeObjectForKey:NAMES_row];
    }
}

- (NSNumber *)row {
    return [store objectForKey:NAMES_row];
}

- (void)setLevel:(NSNumber *)level {
    if (level != nil) {
        [store setObject:level forKey:NAMES_level];
    } else {
        [store removeObjectForKey:NAMES_level];
    }
}

- (NSNumber *)level {
    return [store objectForKey:NAMES_level];
}

- (void)setColumnSpan:(NSNumber *)columnSpan {
    if (columnSpan != nil) {
        [store setObject:columnSpan forKey:NAMES_colSpan];
    } else {
        [store removeObjectForKey:NAMES_colSpan];
    }
}

- (NSNumber *)columnSpan {
    return [store objectForKey:NAMES_colSpan];
}

- (void)setRowSpan:(NSNumber *)rowSpan {
    if (rowSpan != nil) {
        [store setObject:rowSpan forKey:NAMES_rowSpan];
    } else {
        [store removeObjectForKey:NAMES_rowSpan];
    }
}

- (NSNumber *)rowSpan {
    return [store objectForKey:NAMES_rowSpan];
}

- (void)setLevelSpan:(NSNumber *)levelSpan {
    if (levelSpan != nil) {
        [store setObject:levelSpan forKey:NAMES_levelSpan];
    } else {
        [store removeObjectForKey:NAMES_levelSpan];
    }
}

- (NSNumber *)levelSpan {
    return [store objectForKey:NAMES_levelSpan];
}

@end
