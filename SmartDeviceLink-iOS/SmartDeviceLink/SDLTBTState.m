//  SDLTBTState.m
//


#import "SDLTBTState.h"

SDLTBTState *SDLTBTState_ROUTE_UPDATE_REQUEST = nil;
SDLTBTState *SDLTBTState_ROUTE_ACCEPTED = nil;
SDLTBTState *SDLTBTState_ROUTE_REFUSED = nil;
SDLTBTState *SDLTBTState_ROUTE_CANCELLED = nil;
SDLTBTState *SDLTBTState_ETA_REQUEST = nil;
SDLTBTState *SDLTBTState_NEXT_TURN_REQUEST = nil;
SDLTBTState *SDLTBTState_ROUTE_STATUS_REQUEST = nil;
SDLTBTState *SDLTBTState_ROUTE_SUMMARY_REQUEST = nil;
SDLTBTState *SDLTBTState_TRIP_STATUS_REQUEST = nil;
SDLTBTState *SDLTBTState_ROUTE_UPDATE_REQUEST_TIMEOUT = nil;

NSArray *SDLTBTState_values = nil;

@implementation SDLTBTState

+ (SDLTBTState *)valueOf:(NSString *)value {
    for (SDLTBTState *item in SDLTBTState.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTBTState_values == nil) {
        SDLTBTState_values = @[
            SDLTBTState.ROUTE_UPDATE_REQUEST,
            SDLTBTState.ROUTE_ACCEPTED,
            SDLTBTState.ROUTE_REFUSED,
            SDLTBTState.ROUTE_CANCELLED,
            SDLTBTState.ETA_REQUEST,
            SDLTBTState.NEXT_TURN_REQUEST,
            SDLTBTState.ROUTE_STATUS_REQUEST,
            SDLTBTState.ROUTE_SUMMARY_REQUEST,
            SDLTBTState.TRIP_STATUS_REQUEST,
            SDLTBTState.ROUTE_UPDATE_REQUEST_TIMEOUT,
        ];
    }
    return SDLTBTState_values;
}

+ (SDLTBTState *)ROUTE_UPDATE_REQUEST {
    if (SDLTBTState_ROUTE_UPDATE_REQUEST == nil) {
        SDLTBTState_ROUTE_UPDATE_REQUEST = [[SDLTBTState alloc] initWithValue:@"ROUTE_UPDATE_REQUEST"];
    }
    return SDLTBTState_ROUTE_UPDATE_REQUEST;
}

+ (SDLTBTState *)ROUTE_ACCEPTED {
    if (SDLTBTState_ROUTE_ACCEPTED == nil) {
        SDLTBTState_ROUTE_ACCEPTED = [[SDLTBTState alloc] initWithValue:@"ROUTE_ACCEPTED"];
    }
    return SDLTBTState_ROUTE_ACCEPTED;
}

+ (SDLTBTState *)ROUTE_REFUSED {
    if (SDLTBTState_ROUTE_REFUSED == nil) {
        SDLTBTState_ROUTE_REFUSED = [[SDLTBTState alloc] initWithValue:@"ROUTE_REFUSED"];
    }
    return SDLTBTState_ROUTE_REFUSED;
}

+ (SDLTBTState *)ROUTE_CANCELLED {
    if (SDLTBTState_ROUTE_CANCELLED == nil) {
        SDLTBTState_ROUTE_CANCELLED = [[SDLTBTState alloc] initWithValue:@"ROUTE_CANCELLED"];
    }
    return SDLTBTState_ROUTE_CANCELLED;
}

+ (SDLTBTState *)ETA_REQUEST {
    if (SDLTBTState_ETA_REQUEST == nil) {
        SDLTBTState_ETA_REQUEST = [[SDLTBTState alloc] initWithValue:@"ETA_REQUEST"];
    }
    return SDLTBTState_ETA_REQUEST;
}

+ (SDLTBTState *)NEXT_TURN_REQUEST {
    if (SDLTBTState_NEXT_TURN_REQUEST == nil) {
        SDLTBTState_NEXT_TURN_REQUEST = [[SDLTBTState alloc] initWithValue:@"NEXT_TURN_REQUEST"];
    }
    return SDLTBTState_NEXT_TURN_REQUEST;
}

+ (SDLTBTState *)ROUTE_STATUS_REQUEST {
    if (SDLTBTState_ROUTE_STATUS_REQUEST == nil) {
        SDLTBTState_ROUTE_STATUS_REQUEST = [[SDLTBTState alloc] initWithValue:@"ROUTE_STATUS_REQUEST"];
    }
    return SDLTBTState_ROUTE_STATUS_REQUEST;
}

+ (SDLTBTState *)ROUTE_SUMMARY_REQUEST {
    if (SDLTBTState_ROUTE_SUMMARY_REQUEST == nil) {
        SDLTBTState_ROUTE_SUMMARY_REQUEST = [[SDLTBTState alloc] initWithValue:@"ROUTE_SUMMARY_REQUEST"];
    }
    return SDLTBTState_ROUTE_SUMMARY_REQUEST;
}

+ (SDLTBTState *)TRIP_STATUS_REQUEST {
    if (SDLTBTState_TRIP_STATUS_REQUEST == nil) {
        SDLTBTState_TRIP_STATUS_REQUEST = [[SDLTBTState alloc] initWithValue:@"TRIP_STATUS_REQUEST"];
    }
    return SDLTBTState_TRIP_STATUS_REQUEST;
}

+ (SDLTBTState *)ROUTE_UPDATE_REQUEST_TIMEOUT {
    if (SDLTBTState_ROUTE_UPDATE_REQUEST_TIMEOUT == nil) {
        SDLTBTState_ROUTE_UPDATE_REQUEST_TIMEOUT = [[SDLTBTState alloc] initWithValue:@"ROUTE_UPDATE_REQUEST_TIMEOUT"];
    }
    return SDLTBTState_ROUTE_UPDATE_REQUEST_TIMEOUT;
}

@end
