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
        [store setObject:columnSpan forKey:NAMES_colspan];
    } else {
        [store removeObjectForKey:NAMES_colspan];
    }
}

- (NSNumber *)columnSpan {
    return [store objectForKey:NAMES_colspan];
}

- (void)setRowSpan:(NSNumber *)rowSpan {
    if (rowSpan != nil) {
        [store setObject:rowSpan forKey:NAMES_rowspan];
    } else {
        [store removeObjectForKey:NAMES_rowspan];
    }
}

- (NSNumber *)rowSpan {
    return [store objectForKey:NAMES_rowspan];
}

- (void)setLevelSpan:(NSNumber *)levelSpan {
    if (levelSpan != nil) {
        [store setObject:levelSpan forKey:NAMES_levelspan];
    } else {
        [store removeObjectForKey:NAMES_levelspan];
    }
}

- (NSNumber *)levelSpan {
    return [store objectForKey:NAMES_levelspan];
}

@end
