//  SDLFunctionID.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

@import Foundation;


@interface SDLFunctionID : NSObject {

    NSDictionary* functionIDs;
}

-(NSString*) getFunctionName:(int) functionID;
-(NSNumber*) getFunctionID:(NSString*) functionName;

@end
