//  SDLFunctionID.h
//


@import Foundation;


@interface SDLFunctionID : NSObject {

    NSDictionary* functionIDs;
}

-(NSString*) getFunctionName:(int) functionID;
-(NSNumber*) getFunctionID:(NSString*) functionName;

@end
