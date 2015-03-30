//
//  SDLRPCStruct.h


@import Foundation;

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary* store;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict;
-(id) init;

-(NSMutableDictionary*) serializeAsDictionary:(Byte) version;

@end
