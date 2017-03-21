//
//  SDLLogFilter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogFilter.h"

#import "SDLLogFileModule.h"
#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSString (FilterUtilities)

- (BOOL)sdl_containsString:(NSString *)string caseSensitive:(BOOL)caseSensitive;

@end

@implementation NSString (FilterUtilities)

- (BOOL)sdl_containsString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
    NSStringCompareOptions compareOptions = caseSensitive ? 0 : NSCaseInsensitiveSearch;
    return ([self rangeOfString:string options:compareOptions].location != NSNotFound);
}

@end

@interface SDLLogFilter ()

@property (strong, nonatomic, readwrite) SDLLogFilterBlock filter;

@end

@implementation SDLLogFilter

- (instancetype)initWithCustomFilter:(SDLLogFilterBlock)filter {
    self = [super init];
    if (!self) { return nil; }

    _filter = filter;

    return self;
}

#pragma mark - Filter by string

+ (SDLLogFilter *)filterByDisallowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
    // Return YES if it *does not* contain the string
    return [[self alloc] initWithCustomFilter:^BOOL(SDLLogModel *log) {
        return ![log.message sdl_containsString:string caseSensitive:caseSensitive];
    }];
}

+ (SDLLogFilter *)filterByAllowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
    // Return YES if it *does* contain the string
    return [[self alloc] initWithCustomFilter:^BOOL(SDLLogModel *log) {
        return [log.message sdl_containsString:string caseSensitive:caseSensitive];
    }];
}


#pragma mark - Filter by regex

+ (SDLLogFilter *)filterByDisallowingRegex:(NSRegularExpression *)regex {
    // Return YES if it *does not* pass the regex
    return [[self alloc] initWithCustomFilter:^BOOL(SDLLogModel *log) {
        return ([regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)] == 0);
    }];
}

+ (SDLLogFilter *)filterByAllowingRegex:(NSRegularExpression *)regex {
    // Return YES if it *does* pass the regex
    return [[self alloc] initWithCustomFilter:^BOOL(SDLLogModel *log) {
        return ([regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)] != 0);
    }];
}


#pragma mark - Filter by module

+ (SDLLogFilter *)filterByDisallowingModules:(NSSet<NSString *> *)modules {
    // Return YES if the log is *not* in the set of modules
    return [[self alloc] initWithCustomFilter:[self sdl_filterCheckingModules:modules allowed:NO]];
}

+ (SDLLogFilter *)filterByAllowingModules:(NSSet<NSString *> *)modules {
    // Return YES if the log *is* in the set of modules
    return [[self alloc] initWithCustomFilter:[self sdl_filterCheckingModules:modules allowed:YES]];
}

+ (SDLLogFilterBlock)sdl_filterCheckingModules:(NSSet<NSString *> *)modules allowed:(BOOL)allowed {
    return ^BOOL(SDLLogModel *log) {
        for (NSString *module in modules) {
            if ([module isEqualToString:log.moduleName]) {
                return allowed;
            }
        }

        return !allowed;
    };
}


#pragma mark - Filter by file name

+ (SDLLogFilter *)filterByDisallowingFileNames:(NSSet<NSString *> *)fileNames {
    // Return YES if the log is *not* in the set of file names
    return [[self alloc] initWithCustomFilter:[self sdl_filterCheckingFileNames:fileNames allowed:NO]];
}

+ (SDLLogFilter *)filterByAllowingFileNames:(NSSet<NSString *> *)fileNames {
    // Return YES if the log *is* in the set of file names
    return [[self alloc] initWithCustomFilter:[self sdl_filterCheckingFileNames:fileNames allowed:YES]];
}

+ (SDLLogFilterBlock)sdl_filterCheckingFileNames:(NSSet<NSString *> *)fileNames allowed:(BOOL)allowed {
    return ^BOOL(SDLLogModel *log) {
        for (NSString *fileName in fileNames) {
            if ([fileName isEqualToString:log.fileName]) {
                return allowed;
            }
        }

        return !allowed;
    };
}

@end

NS_ASSUME_NONNULL_END
