//  SDLFunctionID.h
//


#import <Foundation/Foundation.h>

#import "SDLNames.h"

@interface SDLFunctionID : NSObject

- (SDLName)getFunctionName:(int)functionID;
- (NSNumber *)getFunctionID:(SDLName)functionName;

@end
