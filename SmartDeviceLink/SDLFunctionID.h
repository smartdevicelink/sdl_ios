//  SDLFunctionID.h
//


#import <Foundation/Foundation.h>

#import "SDLNames.h"

@interface SDLFunctionID : NSObject

+ (instancetype)sharedInstance;

- (SDLName)functionNameForId:(int)functionID;
- (NSNumber *)functionIdForName:(SDLName)functionName;

@end
