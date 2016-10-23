//  SDLFunctionID.h
//


#import <Foundation/Foundation.h>

#import "SDLNames.h"
#import "NSNumber+NumberType.h"

@interface SDLFunctionID : NSObject

+ (instancetype)sharedInstance;

- (SDLName)functionNameForId:(int)functionID;
- (NSNumber<SDLInt> *)functionIdForName:(SDLName)functionName;

@end
