//
//  SDLLogModel.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLogModel

- (instancetype)initWithMessage:(NSString *)message
                      timestamp:(NSDate *)timestamp
                          level:(SDLLogLevel)level
                       fileName:(NSString *)fileName
                     moduleName:(nullable NSString *)moduleName
                   functionName:(NSString *)functionName
                           line:(NSInteger)line
                     queueLabel:(NSString *)queueLabel {
    self = [super init];
    if (!self) { return nil; }

    _message = message;
    _timestamp = timestamp;
    _level = level;
    _fileName = fileName;
    _moduleName = moduleName ? moduleName : @"";
    _functionName = functionName;
    _line = line;
    _queueLabel = queueLabel;

    return self;
}


#pragma mark - Setters / Getters

- (void)setModuleName:(nullable NSString *)moduleName {
    _moduleName = moduleName ? moduleName : @"";
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self copyWithZone:zone] initWithMessage:_message timestamp:_timestamp level:_level fileName:_fileName moduleName:_moduleName functionName:_functionName line:_line queueLabel:_queueLabel];
}


#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLLogModel (%@): timestamp: %@, file name: %@, module: %@, function: %@, line: %ld, queue: %@, message: %@", [self sdl_stringForLogLevel:self.level], self.timestamp, self.fileName, self.moduleName, self.functionName, (long)self.line, self.queueLabel, self.message];
}

- (NSString *)sdl_stringForLogLevel:(SDLLogLevel)level {
    switch (level) {
        case SDLLogLevelOff: return @"Off";
        case SDLLogLevelVerbose: return @"Verbose";
        case SDLLogLevelDebug: return @"Debug";
        case SDLLogLevelWarning: return @"Warning";
        case SDLLogLevelError: return @"Error";
        case SDLLogLevelDefault: return @"Default";
    }
}

@end

NS_ASSUME_NONNULL_END
