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


@implementation SDLLogFilter

#pragma mark - Filter by string

+ (SDLLogFilterBlock)filterByDisallowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
    // Return YES if it *does not* contain the string
    return ^BOOL(SDLLogModel *log) {
        return ![log.message sdl_containsString:string caseSensitive:caseSensitive];
    };
}

+ (SDLLogFilterBlock)filterByAllowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
    // Return YES if it *does* contain the string
    return ^BOOL(SDLLogModel *log) {
        return [log.message sdl_containsString:string caseSensitive:caseSensitive];
    };
}


#pragma mark - Filter by regex

+ (SDLLogFilterBlock)filterByDisallowingRegex:(NSRegularExpression *)regex {
    // Return YES if it *does not* pass the regex
    return ^BOOL(SDLLogModel *log) {
        return ([regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)] == 0);
    };
}

+ (SDLLogFilterBlock)filterByAllowingRegex:(NSRegularExpression *)regex {
    // Return YES if it *does* pass the regex
    return ^BOOL(SDLLogModel *log) {
        return ([regex numberOfMatchesInString:log.message options:0 range:NSMakeRange(0, log.message.length)] != 0);
    };
}


#pragma mark - Filter by module

+ (SDLLogFilterBlock)filterByDisallowingModules:(NSSet<SDLLogFileModule *> *)modules {
    // Return YES if the log is *not* in the set of modules
    return [self sdl_filterCheckingModules:modules allowed:NO];
}

+ (SDLLogFilterBlock)filterByAllowingModules:(NSSet<SDLLogFileModule *> *)modules {
    // Return YES if the log *is* in the set of modules
    return [self sdl_filterCheckingModules:modules allowed:YES];
}

+ (SDLLogFilterBlock)sdl_filterCheckingModules:(NSSet<SDLLogFileModule *> *)modules allowed:(BOOL)allowed {
    return ^BOOL(SDLLogModel *log) {
        for (SDLLogFileModule *module in modules) {
            if ([module.name isEqualToString:log.moduleName]) {
                return allowed;
            }
        }

        return !allowed;
    };
}


#pragma mark - Filter by file name

+ (SDLLogFilterBlock)filterByDisallowingFileNames:(NSSet<NSString *> *)fileNames {
    // Return YES if the log is *not* in the set of file names
    return [self sdl_filterCheckingFileNames:fileNames allowed:NO];
}

+ (SDLLogFilterBlock)filterByAllowingFileNames:(NSSet<NSString *> *)fileNames {
    // Return YES if the log *is* in the set of file names
    return [self sdl_filterCheckingFileNames:fileNames allowed:YES];
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
