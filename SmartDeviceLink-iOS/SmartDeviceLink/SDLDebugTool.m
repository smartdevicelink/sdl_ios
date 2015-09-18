//  SDLDebugTool.m
//

#import "SDLDebugTool.h"
#import "SDLRPCMessage.h"
#import "SDLSiphonServer.h"
#import "SDLHexUtility.h"
#import "NSThread+ThreadIndex.h"

#define LOG_ERROR_ENABLED

static NSMutableDictionary *namedConsoleSets = nil;

bool debugToLogFile = false;


@implementation SDLDebugTool


#pragma mark - Console Management
+ (void)addConsole:(NSObject<SDLDebugToolConsole> *)console {
    [self addConsole:console toGroup:@"default"];
}

+ (void)addConsole:(NSObject<SDLDebugToolConsole> *)console toGroup:(NSString *)groupName {
    // Make sure master dictionary exists
    if (namedConsoleSets == nil) {
        namedConsoleSets = [NSMutableDictionary new];
    }

    // Make sure the set to contain this group's elements exists
    if ([namedConsoleSets objectForKey:groupName] == nil) {
        [namedConsoleSets setValue:[NSMutableSet new] forKey:groupName];
    }

    // Add the console to the set
    [[namedConsoleSets valueForKey:groupName] addObject:console];
}

+ (void)removeConsole:(NSObject<SDLDebugToolConsole> *)console {
    [self removeConsole:console fromGroup:@"default"];
}

+ (void)removeConsole:(NSObject<SDLDebugToolConsole> *)console fromGroup:(NSString *)groupName {
    [[SDLDebugTool getConsoleListenersForGroup:groupName] removeObject:console];
}

+ (NSMutableSet *)getConsoleListenersForGroup:(NSString *)groupName {
    return [namedConsoleSets valueForKey:groupName];
}


#pragma mark - logging
+ (void)logInfo:(NSString *)info {
    [self logInfo:info withType:SDLDebugType_Debug toOutput:SDLDebugOutput_All toGroup:@"default"];
}

+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type {
    [self logInfo:info withType:type toOutput:SDLDebugOutput_All toGroup:@"default"];
}

+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output {
    [SDLDebugTool logInfo:info withType:type toOutput:output toGroup:@"default"];
}

+ (void)logInfo:(NSString *)info andBinaryData:(NSData *)data withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output {
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
    // Format the message, prepend the thread id
    NSMutableString *outputString = [NSMutableString stringWithFormat:@"[%li] %@", (long)[[NSThread currentThread] threadIndex], info];


    ////////////////////////////////////////////////
    //
    //  Output to the various destinations
    //
    ////////////////////////////////////////////////

    //Output To DeviceConsole
    if (output & SDLDebugOutput_DeviceConsole) {
        NSLog(@"%@", outputString);
    }

    //Output To DebugToolConsoles
    if (output & SDLDebugOutput_DebugToolConsole) {
        NSSet *consoleListeners = [self getConsoleListenersForGroup:consoleGroupName];
        for (NSObject<SDLDebugToolConsole> *console in consoleListeners) {
            [console logInfo:outputString];
        }
    }

    //Output To LogFile
    if (output & SDLDebugOutput_File) {
        [SDLDebugTool writeToLogFile:outputString];
    }

    //Output To Siphon
    [SDLSiphonServer init];
    [SDLSiphonServer _siphonNSLogData:outputString];
}


#pragma mark - file handling
+ (void)enableDebugToLogFile {
    debugToLogFile = true;

    [SDLDebugTool logInfo:@"Log File Enabled" withType:SDLDebugType_Debug];

    //Delete Log File If It Exists
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"smartdevicelink.log"];

    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        [SDLDebugTool logInfo:@"Log File Exisits, Deleteing" withType:SDLDebugType_Debug];
        [manager removeItemAtPath:filePath error:nil];
    }
}

+ (void)disableDebugToLogFile {
    debugToLogFile = false;
}

+ (void)writeToLogFile:(NSString *)info {
    // Warning: do not call any logInfo method from here. recursion of death.

    if (!debugToLogFile || info == NULL || info.length == 0) {
        return;
    }

    // Create timestamp string, add it in front of the message to be logged
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YY HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *outputString = [dateString stringByAppendingFormat:@": %@\n", info];

    // file write takes an NSData, so convert string to data.
    NSData *dataToLog = [outputString dataUsingEncoding:NSUTF8StringEncoding];

    // If open/create file and write
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"smartdevicelink.log"];

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (fileHandle) {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:dataToLog];
        [fileHandle closeFile];
    } else {
        [dataToLog writeToFile:filePath atomically:NO];
    }
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
