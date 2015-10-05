//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataResultCode;


@interface SDLDIDResult : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLVehicleDataResultCode *resultCode;
@property (strong) NSNumber *didLocation;
@property (strong) NSString *data;

@end
