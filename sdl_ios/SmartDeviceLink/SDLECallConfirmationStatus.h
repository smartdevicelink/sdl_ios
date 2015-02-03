//  SDLECallConfirmationStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLECallConfirmationStatus : SDLEnum {}

+(SDLECallConfirmationStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLECallConfirmationStatus*) NORMAL;
+(SDLECallConfirmationStatus*) CALL_IN_PROGRESS;
+(SDLECallConfirmationStatus*) CALL_CANCELLED;
+(SDLECallConfirmationStatus*) CALL_COMPLETED;
+(SDLECallConfirmationStatus*) CALL_UNSUCCESSFUL;
+(SDLECallConfirmationStatus*) ECALL_CONFIGURED_OFF;
+(SDLECallConfirmationStatus*) CALL_COMPLETE_DTMF_TIMEOUT;

@end
