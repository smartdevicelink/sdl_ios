//  SDLDebugTool.m
//

#import "SDLDebugTool.h"
#import "NSThread+ThreadIndex.h"
#import "SDLHexUtility.h"
#import "SDLRPCMessage.h"
#import "SDLSiphonServer.h"


@interface SDLDebugTool ()

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL debugToLogFile;
@property (nonatomic, strong) NSMutableDictionary *namedConsoleSets;
@property (nonatomic, strong) NSDateFormatter *logDateFormatter;
@property (nonatomic, strong) NSFileHandle *logFileHandle;
@property (nonatomic, strong) dispatch_queue_t logQueue;

@end


@implementation SDLDebugTool

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _enabled = YES;
    _debugToLogFile = NO;
    _logQueue = dispatch_queue_create("com.sdl.log.file", DISPATCH_QUEUE_SERIAL);

    return self;
}

+ (SDLDebugTool *)sharedTool {
    static SDLDebugTool *sharedTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTool = [[self alloc] init];
    });

    return sharedTool;
}

+ (void)enable {
    [SDLDebugTool sharedTool].enabled = YES;
}

+ (void)disable {
    [SDLDebugTool sharedTool].enabled = NO;
}


#pragma mark - Console Management

+ (void)addConsole:(NSObject<SDLDebugToolConsole> *)console {
    [self addConsole:console toGroup:@"default"];
}

- (void)sdl_addConsole:(NSObject<SDLDebugToolConsole> *)console toGroup:(NSString *)groupName {
    // Make sure master dictionary exists
    if (self.namedConsoleSets == nil) {
        self.namedConsoleSets = [NSMutableDictionary new];
    }

    // Make sure the set to contain this group's elements exists
    if ([self.namedConsoleSets objectForKey:groupName] == nil) {
        [self.namedConsoleSets setValue:[NSMutableSet new] forKey:groupName];
    }

    // Add the console to the set
    [[self.namedConsoleSets valueForKey:groupName] addObject:console];
}

+ (void)addConsole:(NSObject<SDLDebugToolConsole> *)console toGroup:(NSString *)groupName {
    [[self sharedTool] sdl_addConsole:console toGroup:groupName];
}

+ (void)removeConsole:(NSObject<SDLDebugToolConsole> *)console {
    [self removeConsole:console fromGroup:@"default"];
}

+ (void)removeConsole:(NSObject<SDLDebugToolConsole> *)console fromGroup:(NSString *)groupName {
    [[SDLDebugTool getConsoleListenersForGroup:groupName] removeObject:console];
}

+ (NSMutableSet *)getConsoleListenersForGroup:(NSString *)groupName {
    return [[self sharedTool] sdl_getConsoleListenersForGroup:groupName];
}

- (NSMutableSet *)sdl_getConsoleListenersForGroup:(NSString *)groupName {
    return [self.namedConsoleSets valueForKey:groupName];
}


#pragma mark - Logging

+ (void)logInfo:(NSString *)info {
    [self logInfo:info withType:SDLDebugType_Debug toOutput:SDLDebugOutput_All toGroup:@"default"];
}

+ (void)logFormat:(NSString *)info, ... {
    va_list args;
    va_start(args, info);

    NSString *format = [[NSString alloc] initWithFormat:info arguments:args];
    [self logInfo:format];
}

+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type {
    [self logInfo:info withType:type toOutput:SDLDebugOutput_All toGroup:@"default"];
}

+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output {
    [SDLDebugTool logInfo:info withType:type toOutput:output toGroup:@"default"];
}

+ (void)logInfo:(NSString *)info andBinaryData:(NSData *)data withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output {
    if (![SDLDebugTool sharedTool].enabled) {
        return;
    }

    // convert binary data to string, append the two strings, then pass to usual log method.
    NSMutableString *outputString = [[NSMutableString alloc] init];
    if (info) {
        [outputString appendString:info];
    }

    if (data) {
        @autoreleasepool {
            NSString *dataString = [SDLHexUtility getHexString:data];
            if (dataString) {
                [outputString appendString:dataString];
            }
        }
    }

    [SDLDebugTool logInfo:outputString withType:type toOutput:output toGroup:@"default"];
}

// The designated logInfo method. All outputs should be performed here.
+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output toGroup:(NSString *)consoleGroupName {
    if (![SDLDebugTool sharedTool].enabled) {
        return;
    }

    // Format the message, prepend the thread id
    NSString *outputString = [NSString stringWithFormat:@"[%li] %@", (long)[[NSThread currentThread] threadIndex], info];

    //  Output to the various destinations

    //Output To DeviceConsole
    if ((output & SDLDebugOutput_DeviceConsole) == SDLDebugOutput_DeviceConsole) {
        NSLog(@"%@", outputString);
    }

    //Output To DebugToolConsoles
    if ((output & SDLDebugOutput_DebugToolConsole) == SDLDebugOutput_DebugToolConsole) {
        NSSet *consoleListeners = [self getConsoleListenersForGroup:consoleGroupName];
        for (NSObject<SDLDebugToolConsole> *console in consoleListeners) {
            [console logInfo:outputString];
        }
    }

    //Output To LogFile
    if ((output & SDLDebugOutput_File) == SDLDebugOutput_File) {
        [SDLDebugTool writeToLogFile:outputString];
    }

    //Output To Siphon
    [SDLSiphonServer init];
    [SDLSiphonServer _siphonNSLogData:outputString];
}


#pragma mark - File Handling

+ (void)enableDebugToLogFile {
    [[self sharedTool] sdl_enableDebugToLogFile];
}

- (void)sdl_enableDebugToLogFile {
    if (self.debugToLogFile) {
        return;
    }

    [SDLDebugTool logInfo:@"Enabling Log File" withType:SDLDebugType_Debug];

    self.debugToLogFile = YES;

    //Delete Log File If It Exists
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"smartdevicelink.log"];

    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        [manager removeItemAtPath:filePath error:nil];
    }

    // Create log file
    [manager createFileAtPath:filePath contents:nil attributes:nil];
    self.logFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [self.logFileHandle seekToEndOfFile];
}

+ (void)disableDebugToLogFile {
    [[self sharedTool] sdl_disableDebugToLogFile];
}

- (void)sdl_disableDebugToLogFile {
    self.debugToLogFile = false;
}

+ (void)writeToLogFile:(NSString *)info {
    [[self sharedTool] sdl_writeToLogFile:info];
}

- (void)sdl_writeToLogFile:(NSString *)info {
    // Warning: do not call any logInfo method from here. recursion of death.
    if (!self.debugToLogFile || info == NULL || info.length == 0) {
        return;
    }

    dispatch_async(self.logQueue, ^{
        // Create timestamp string, add it in front of the message to be logged
        NSDate *currentDate = [NSDate date];
        NSString *dateString = [self.logDateFormatter stringFromDate:currentDate];
        NSString *outputString = [dateString stringByAppendingFormat:@": %@\n", info];

        // File write takes an NSData, so convert string to data.
        NSData *dataToLog = [outputString dataUsingEncoding:NSUTF8StringEncoding];

        if (self.logFileHandle != nil) {
            [self.logFileHandle seekToEndOfFile];
            [self.logFileHandle writeData:dataToLog];
        } else {
            NSLog(@"SDL ERROR: Unable to log to file. File handle does not exist.");
        }
    });
}

- (NSDateFormatter *)logDateFormatter {
    if (_logDateFormatter == nil) {
        _logDateFormatter = [[NSDateFormatter alloc] init];
        [_logDateFormatter setDateFormat:@"MM/dd/YY HH:mm:ss.SSS"];
    }

    return _logDateFormatter;
}


#pragma mark - Helper Methods

+ (NSString *)stringForDebugType:(SDLDebugType)debugType {
    switch (debugType) {
        case SDLDebugType_Debug:
            return @"DBG";
            break;
        case SDLDebugType_Transport_iAP:
            return @"iAP";
            break;
        case SDLDebugType_Transport_TCP:
            return @"TCP";
            break;
        case SDLDebugType_Protocol:
            return @"Pro";
            break;
        case SDLDebugType_RPC:
            return @"RPC";
            break;
        case SDLDebugType_APP:
            return @"APP";
            break;

        default:
            return @"Invalid DebugType";
            break;
    }
}

@end
