//  SDLSiphonServer.h
//


#import <Foundation/Foundation.h>

@interface SDLSiphonServer : NSObject <NSStreamDelegate, NSNetServiceDelegate> {
}

+ (void)enableSiphonDebug;
+ (void)disableSiphonDebug;
+ (bool)_siphonRawTransportDataFromApp:(const void *)msgBytes msgBytesLength:(int)msgBytesLength;
+ (bool)_siphonRawTransportDataFromSDL:(const void *)msgBytes msgBytesLength:(int)msgBytesLength;
+ (bool)_siphonNSLogData:(NSString *)textToLog;
+ (bool)_siphonFormattedTraceData:(NSString *)traceData;
+ (bool)_siphonIsActive;
+ (void)init;
+ (void)dealloc;

@end
