//  SDLFunctionID.h
//


#import <Foundation/Foundation.h>


@interface SDLFunctionID : NSObject {
    NSDictionary *functionIDs;
}

- (NSString *)getFunctionName:(int)functionID;
- (NSNumber *)getFunctionID:(NSString *)functionName;

@end
