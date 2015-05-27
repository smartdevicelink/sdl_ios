//
//  SDLRPCStruct.h


@import Foundation;

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary* store;
}

-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;
-(instancetype) init;

-(NSMutableDictionary*) serializeAsDictionary:(Byte) version;

@end
