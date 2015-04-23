//  SDLRPCMessageType.m
//


#import "SDLRPCMessageType.h"

SDLRPCMessageType* SDLRPCMessageType_request = nil;
SDLRPCMessageType* SDLRPCMessageType_response = nil;
SDLRPCMessageType* SDLRPCMessageType_notification = nil;

NSArray* SDLRPCMessageType_values = nil;
@implementation SDLRPCMessageType

+(SDLRPCMessageType*) valueOf:(NSString*) value {
    for (SDLRPCMessageType* item in SDLRPCMessageType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSArray*) values {
    if (SDLRPCMessageType_values == nil) {
        SDLRPCMessageType_values = @[
                                     [SDLRPCMessageType request],
                                     [SDLRPCMessageType response],
                                     [SDLRPCMessageType notification],
                                     ];
    }
    return SDLRPCMessageType_values;
}

+(SDLRPCMessageType*) request {
    if (SDLRPCMessageType_request == nil) {
        SDLRPCMessageType_request = [[SDLRPCMessageType alloc] initWithValue:@"request"];
    }
    return SDLRPCMessageType_request;
}

+(SDLRPCMessageType*) response {
    if (SDLRPCMessageType_response == nil) {
        SDLRPCMessageType_response = [[SDLRPCMessageType alloc] initWithValue:@"response"];
    }
    return SDLRPCMessageType_response;
}

+(SDLRPCMessageType*) notification {
    if (SDLRPCMessageType_notification == nil) {
        SDLRPCMessageType_notification = [[SDLRPCMessageType alloc] initWithValue:@"notification"];
    }
    return SDLRPCMessageType_notification;
}

@end
