//
//  SDLLogManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogManager.h"

#import "SDLGlobals.h"
#import "SDLHexUtility.h"
#import "SDLLogConfiguration.h"
#import "SDLLogFileModule.h"
#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLogManager ()

@property (copy, nonatomic, readwrite) NSSet<SDLLogFileModule *> *modules;
@property (copy, nonatomic, readwrite) NSSet<id<SDLLogTarget>> *targets;
@property (copy, nonatomic, readwrite) NSSet<SDLLogFilter *> *filters;

@property (assign, nonatomic, readwrite) SDLLogLevel globalLogLevel;
@property (assign, nonatomic, readwrite) SDLLogFormatType formatType;

@property (assign, nonatomic, readwrite, getter=isAsynchronous) BOOL asynchronous;
@property (assign, nonatomic, readwrite, getter=areErrorsAsynchronous) BOOL errorsAsynchronous;
@property (assign, nonatomic, readwrite, getter=areAssertionsDisabled) BOOL disableAssertions;

@end

@implementation SDLLogManager

static NSDateFormatter *_dateFormatter = nil;
static dispatch_queue_t _logQueue = NULL;

+ (SDLLogManager *)sharedManager {
    static SDLLogManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SDLLogManager alloc] init];
    });

    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _modules = [NSSet set];
    _targets = [NSSet set];
    _filters = [NSSet set];

    _asynchronous = YES;
    _errorsAsynchronous = NO;
    _disableAssertions = NO;
    _globalLogLevel = SDLLogLevelError;
    _formatType = SDLLogFormatTypeDefault;

    return self;
}


#pragma mark - Configuration

+ (void)setConfiguration:(SDLLogConfiguration *)configuration {
    [[self sharedManager] setConfiguration:configuration];
}

- (void)setConfiguration:(SDLLogConfiguration *)configuration {
    self.modules = configuration.modules;
    self.filters = configuration.filters;
    self.formatType = configuration.formatType;
    self.asynchronous = configuration.isAsynchronous;
    self.errorsAsynchronous = configuration.areErrorsAsynchronous;
    self.disableAssertions = configuration.areAssertionsDisabled;
    self.globalLogLevel = configuration.globalLogLevel;

    // Start the loggers
    NSMutableSet<id<SDLLogTarget>> *startedLoggers = [NSMutableSet set];
    for (id<SDLLogTarget> target in configuration.targets) {
        // If the logger fails setup, discard it, otherwise, keep it
        if ([target setupLogger]) {
            [startedLoggers addObject:target];
        } else {
            // Because we haven't set up loggers yet, this is necessary
            NSLog(@"(SDL) Warning: Log target failed setup: %@", NSStringFromClass(target.class));
        }
    }
    self.targets = [startedLoggers copy];
}


#pragma mark - Performing Logging

+ (void)logBytes:(NSData *)data direction:(SDLLogBytesDirection)direction timestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel {
    [[self sharedManager] logBytes:data direction:direction timestamp:timestamp file:file functionName:functionName line:line queue:queueLabel];
}

+ (void)logAssertWithTimestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel formatMessage:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);

    [[self sharedManager] logAssertWithTimestamp:timestamp file:file functionName:functionName line:line queue:queueLabel formatMessage:@"%@", format];
}

+ (void)logWithLevel:(SDLLogLevel)level timestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel message:(NSString *)message {
    [[self sharedManager] logWithLevel:level timestamp:timestamp file:file functionName:functionName line:line queue:queueLabel message:message];
}

+ (void)logWithLevel:(SDLLogLevel)level timestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel formatMessage:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);

    [[self sharedManager] logWithLevel:level timestamp:timestamp file:file functionName:functionName line:line queue:queueLabel message:format];
}

- (void)logBytes:(NSData *)data direction:(SDLLogBytesDirection)direction timestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel {
    // This only works on Verbose logging
    if ([self sdl_logLevelForFile:file] < SDLLogLevelVerbose) { return; }

    NSString *message = [NSString stringWithFormat:@"%@(%lu bytes): %@", [self sdl_logStringForDirection:direction], (unsigned long)data.length, [SDLHexUtility getHexString:data]];
    [self logWithLevel:SDLLogLevelVerbose timestamp:timestamp file:file functionName:functionName line:line queue:queueLabel message:message];
}

- (void)logAssertWithTimestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel formatMessage:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);

    [self logWithLevel:SDLLogLevelError timestamp:timestamp file:file functionName:functionName line:line queue:queueLabel message:format];

    NSAssert(self.areAssertionsDisabled, @"SDL ASSERTION: %@. To disable these assertions, alter your `SDLLogConfiguration` and set `disableAssertions` to `YES`", format);
}

- (void)logWithLevel:(SDLLogLevel)level timestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel formatMessage:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    NSString *format = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);

    [self logWithLevel:level timestamp:timestamp file:file functionName:functionName line:line queue:queueLabel message:format];
}

- (void)logWithLevel:(SDLLogLevel)level timestamp:(NSDate *)timestamp file:(NSString *)file functionName:(NSString *)functionName line:(NSInteger)line queue:(NSString *)queueLabel message:(NSString *)message {
    NSString *moduleName = [self sdl_moduleForFile:file] ? [self sdl_moduleForFile:file].name : @"";

    SDLLogModel *log = [[SDLLogModel alloc] initWithMessage:message
                                                  timestamp:timestamp
                                                      level:level
                                                   fileName:file
                                                 moduleName:moduleName
                                               functionName:functionName
                                                       line:line
                                                 queueLabel:queueLabel];
    [self sdl_queueLog:log];
}

- (void)sdl_queueLog:(SDLLogModel *)log {
    if (log.level == SDLLogLevelError) {
        if (self.areErrorsAsynchronous) {
            [self sdl_asyncLog:log];
        } else {
            [self sdl_syncLog:log];
        }
    } else {
        if (self.isAsynchronous) {
            [self sdl_asyncLog:log];
        } else {
            [self sdl_syncLog:log];
        }
    }
}

- (void)sdl_asyncLog:(SDLLogModel *)log {
    dispatch_async(self.class.logQueue, ^{
        [self sdl_log:log];
    });
}

- (void)sdl_syncLog:(SDLLogModel *)log {
    [self sdl_log:log];
}

- (void)sdl_log:(SDLLogModel *)log {
    if ([self sdl_logLevelForFile:log.fileName] < log.level) { return; }

    for (SDLLogFilter *filter in self.filters) {
        if (!filter.filter(log)) { return; }
    }

    NSString *formattedLog = nil;
    switch (self.formatType) {
        case SDLLogFormatTypeSimple:
            formattedLog = [self sdl_simpleFormatLog:log];
            break;
        case SDLLogFormatTypeDefault:
            formattedLog = [self sdl_defaultFormatLog:log];
            break;
        case SDLLogFormatTypeDetailed:
            formattedLog = [self sdl_detailedFormatLog:log];
            break;
    }

    for (id<SDLLogTarget> target in self.targets) {
        [target logWithLog:log formattedLog:formattedLog];
    }
}


#pragma mark - Log formatting

- (NSString *)sdl_simpleFormatLog:(SDLLogModel *)log {
    return [self sdl_formatLog:log showDate:YES showLogLevelCharacter:YES showLogLevelName:NO showQueueName:NO showModuleName:YES showFileName:NO showFunctionName:NO showLine:NO];
}

- (NSString *)sdl_defaultFormatLog:(SDLLogModel *)log {
    return [self sdl_formatLog:log showDate:YES showLogLevelCharacter:YES showLogLevelName:NO showQueueName:NO showModuleName:YES showFileName:YES showFunctionName:NO showLine:YES];
}

- (NSString *)sdl_detailedFormatLog:(SDLLogModel *)log {
    return [self sdl_formatLog:log showDate:YES showLogLevelCharacter:YES showLogLevelName:YES showQueueName:YES showModuleName:YES showFileName:YES showFunctionName:YES showLine:YES];
}

- (NSString *)sdl_formatLog:(SDLLogModel *)log showDate:(BOOL)date showLogLevelCharacter:(BOOL)logChar showLogLevelName:(BOOL)logName showQueueName:(BOOL)queueName showModuleName:(BOOL)moduleName showFileName:(BOOL)fileName showFunctionName:(BOOL)functionName showLine:(BOOL)line {
    NSMutableString *logString = [NSMutableString string];

    if (date) {
        [logString appendFormat:@"%@ ", [self.class.dateFormatter stringFromDate:log.timestamp]];
    }
    if (logChar) {
        [logString appendFormat:@"%@ ", [self sdl_logCharacterForLevel:log.level]];
    }
    if (logName) {
        [logString appendFormat:@"%@ ", [self sdl_logNameForLevel:log.level]];
    }
    if (queueName) {
        [logString appendFormat:@"%@ ", log.queueLabel];
    }
    if (moduleName) {
        [logString appendFormat:@"(SDL)%@", log.moduleName];
    }
    if (fileName) {
        [logString appendFormat:@":%@", log.fileName];
    }
    if (functionName) {
        [logString appendFormat:@":%@", log.functionName];
    }
    if (line) {
        [logString appendFormat:@":%ld ", (long)log.line];
    }
    [logString appendFormat:@"- %@\n", log.message];

    return [logString copy];
}

- (NSString *)sdl_logCharacterForLevel:(SDLLogLevel)logLevel {
    switch (logLevel) {
        case SDLLogLevelVerbose: return @"⚪";
        case SDLLogLevelDebug: return @"🔵";
        case SDLLogLevelWarning: return @"🔶";
        case SDLLogLevelError: return @"❌";
        default:
            NSAssert(NO, @"The OFF and DEFAULT log levels are not valid to log with.");
            return @"";
    }
}

- (NSString *)sdl_logNameForLevel:(SDLLogLevel)logLevel {
    switch (logLevel) {
        case SDLLogLevelVerbose: return @"VERBOSE";
        case SDLLogLevelDebug: return @"DEBUG";
        case SDLLogLevelWarning: return @"WARNING";
        case SDLLogLevelError: return @"ERROR";
        default:
            NSAssert(NO, @"The OFF and DEFAULT log levels are not valid to log with.");
            return @"UNKNOWN";
    }
}

- (NSString *)sdl_logStringForDirection:(SDLLogBytesDirection)direction {
    switch (direction) {
        case SDLLogBytesDirectionReceive:
            return @"RX";
        case SDLLogBytesDirectionTransmit:
            return @"TX";
    }
}


#pragma mark - Modules

- (SDLLogLevel)sdl_logLevelForFile:(NSString *)fileName {
    SDLLogFileModule *module = [self sdl_moduleForFile:fileName];
    if (!module) {
        return self.globalLogLevel;
    }

    if ([module containsFile:fileName]) {
        if (module.logLevel == SDLLogLevelDefault) {
            return self.globalLogLevel;
        }
    }

    return module.logLevel;
}

- (nullable SDLLogFileModule *)sdl_moduleForFile:(NSString *)fileName {
    for (SDLLogFileModule *module in self.modules) {
        if ([module containsFile:fileName]) { return module; }
    }

    return nil;
}


#pragma mark - Class property getters

+ (NSDateFormatter *)dateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:mm:ss:SSS";
    });

    return _dateFormatter;
}

+ (dispatch_queue_t)logQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _logQueue = dispatch_queue_create_with_target("com.sdl.log", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    });

    return _logQueue;
}

@end

NS_ASSUME_NONNULL_END
