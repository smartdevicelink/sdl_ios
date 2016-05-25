//  SDLECallConfirmationStatus.m
//


#import "SDLECallConfirmationStatus.h"

SDLECallConfirmationStatus *SDLECallConfirmationStatus_NORMAL = nil;
SDLECallConfirmationStatus *SDLECallConfirmationStatus_CALL_IN_PROGRESS = nil;
SDLECallConfirmationStatus *SDLECallConfirmationStatus_CALL_CANCELLED = nil;
SDLECallConfirmationStatus *SDLECallConfirmationStatus_CALL_COMPLETED = nil;
SDLECallConfirmationStatus *SDLECallConfirmationStatus_CALL_UNSUCCESSFUL = nil;
SDLECallConfirmationStatus *SDLECallConfirmationStatus_ECALL_CONFIGURED_OFF = nil;
SDLECallConfirmationStatus *SDLECallConfirmationStatus_CALL_COMPLETE_DTMF_TIMEOUT = nil;

NSArray *SDLECallConfirmationStatus_values = nil;

@implementation SDLECallConfirmationStatus

+ (SDLECallConfirmationStatus *)valueOf:(NSString *)value {
    for (SDLECallConfirmationStatus *item in SDLECallConfirmationStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLECallConfirmationStatus_values == nil) {
        SDLECallConfirmationStatus_values = @[
            SDLECallConfirmationStatus.NORMAL,
            SDLECallConfirmationStatus.CALL_IN_PROGRESS,
            SDLECallConfirmationStatus.CALL_CANCELLED,
            SDLECallConfirmationStatus.CALL_COMPLETED,
            SDLECallConfirmationStatus.CALL_UNSUCCESSFUL,
            SDLECallConfirmationStatus.ECALL_CONFIGURED_OFF,
            SDLECallConfirmationStatus.CALL_COMPLETE_DTMF_TIMEOUT,
        ];
    }
    return SDLECallConfirmationStatus_values;
}

+ (SDLECallConfirmationStatus *)NORMAL {
    if (SDLECallConfirmationStatus_NORMAL == nil) {
        SDLECallConfirmationStatus_NORMAL = [[SDLECallConfirmationStatus alloc] initWithValue:@"NORMAL"];
    }
    return SDLECallConfirmationStatus_NORMAL;
}

+ (SDLECallConfirmationStatus *)CALL_IN_PROGRESS {
    if (SDLECallConfirmationStatus_CALL_IN_PROGRESS == nil) {
        SDLECallConfirmationStatus_CALL_IN_PROGRESS = [[SDLECallConfirmationStatus alloc] initWithValue:@"CALL_IN_PROGRESS"];
    }
    return SDLECallConfirmationStatus_CALL_IN_PROGRESS;
}

+ (SDLECallConfirmationStatus *)CALL_CANCELLED {
    if (SDLECallConfirmationStatus_CALL_CANCELLED == nil) {
        SDLECallConfirmationStatus_CALL_CANCELLED = [[SDLECallConfirmationStatus alloc] initWithValue:@"CALL_CANCELLED"];
    }
    return SDLECallConfirmationStatus_CALL_CANCELLED;
}

+ (SDLECallConfirmationStatus *)CALL_COMPLETED {
    if (SDLECallConfirmationStatus_CALL_COMPLETED == nil) {
        SDLECallConfirmationStatus_CALL_COMPLETED = [[SDLECallConfirmationStatus alloc] initWithValue:@"CALL_COMPLETED"];
    }
    return SDLECallConfirmationStatus_CALL_COMPLETED;
}

+ (SDLECallConfirmationStatus *)CALL_UNSUCCESSFUL {
    if (SDLECallConfirmationStatus_CALL_UNSUCCESSFUL == nil) {
        SDLECallConfirmationStatus_CALL_UNSUCCESSFUL = [[SDLECallConfirmationStatus alloc] initWithValue:@"CALL_UNSUCCESSFUL"];
    }
    return SDLECallConfirmationStatus_CALL_UNSUCCESSFUL;
}

+ (SDLECallConfirmationStatus *)ECALL_CONFIGURED_OFF {
    if (SDLECallConfirmationStatus_ECALL_CONFIGURED_OFF == nil) {
        SDLECallConfirmationStatus_ECALL_CONFIGURED_OFF = [[SDLECallConfirmationStatus alloc] initWithValue:@"ECALL_CONFIGURED_OFF"];
    }
    return SDLECallConfirmationStatus_ECALL_CONFIGURED_OFF;
}

+ (SDLECallConfirmationStatus *)CALL_COMPLETE_DTMF_TIMEOUT {
    if (SDLECallConfirmationStatus_CALL_COMPLETE_DTMF_TIMEOUT == nil) {
        SDLECallConfirmationStatus_CALL_COMPLETE_DTMF_TIMEOUT = [[SDLECallConfirmationStatus alloc] initWithValue:@"CALL_COMPLETE_DTMF_TIMEOUT"];
    }
    return SDLECallConfirmationStatus_CALL_COMPLETE_DTMF_TIMEOUT;
}

@end
