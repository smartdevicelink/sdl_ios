//  SDLEncodedSyncPData.h
//



#import "SDLRPCRequest.h"

@interface SDLEncodedSyncPData : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* data;

@end
