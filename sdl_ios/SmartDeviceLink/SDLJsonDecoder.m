//  SDLJsonDecoder.m
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLJsonDecoder.h>
#import <SmartDeviceLink/SDLNames.h>

@implementation SDLJsonDecoder

static NSObject<SDLDecoder>* jsonDecoderInstance;

+(NSObject<SDLDecoder>*) instance {
    if (jsonDecoderInstance == nil) {
        jsonDecoderInstance = [[SDLJsonDecoder alloc] init];
    }
    return jsonDecoderInstance;
}

- (NSDictionary *)decode:(NSData *)data {

    if(data == nil) {
        NSLog(@"Warning: No JSON data to decode.");
        return nil;
    }

    if(data.length == 0) {
        NSLog(@"Warning: Cannot decode 0 length data.");
        return nil;
    }


    NSError* error;
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return jsonObject;
}

@end
