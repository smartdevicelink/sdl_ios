//  SDLDebugTool.h
//


#import "SDLDebugToolConsole.h"
#import <Foundation/Foundation.h>

@class SDLRPCMessage;


typedef NS_ENUM(UInt8, SDLDebugType) {
    SDLDebugType_Debug = 0,
    SDLDebugType_Transport_iAP = 1,
    SDLDebugType_Transport_TCP = 2,
    SDLDebugType_Protocol = 3,
    SDLDebugType_RPC = 4,
    SDLDebugType_APP = 5
};

typedef NS_ENUM(UInt8, SDLDebugOutput) {
    SDLDebugOutput_All = 0xFF,
    SDLDebugOutput_DeviceConsole = 1,
    SDLDebugOutput_DebugToolConsole = 2,
    SDLDebugOutput_File = 4
};


@interface SDLDebugTool : NSObject {
}

+ (void)enable;
+ (void)disable;
+ (void)addConsole:(NSObject<SDLDebugToolConsole> *)console;
+ (void)addConsole:(NSObject<SDLDebugToolConsole> *)console toGroup:(NSString *)groupName;
+ (void)removeConsole:(NSObject<SDLDebugToolConsole> *)console;
+ (void)removeConsole:(NSObject<SDLDebugToolConsole> *)console fromGroup:(NSString *)groupName;
+ (void)logInfo:(NSString *)info;
+ (void)logFormat:(NSString *)info, ...;
+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type;
+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output;
+ (void)logInfo:(NSString *)info andBinaryData:(NSData *)data withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output;
+ (void)logInfo:(NSString *)info withType:(SDLDebugType)type toOutput:(SDLDebugOutput)output toGroup:(NSString *)consoleGroupName;

+ (void)enableDebugToLogFile;
+ (void)disableDebugToLogFile;
+ (void)writeToLogFile:(NSString *)info;

+ (NSString *)stringForDebugType:(SDLDebugType)type;


@end
