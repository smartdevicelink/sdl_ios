//  SDLJsonDecoder.m
//

#import "SDLJsonDecoder.h"

#import "SDLDebugTool.h"
#import "SDLNames.h"


@implementation SDLJsonDecoder

static NSObject<SDLDecoder> *jsonDecoderInstance;

+ (NSObject<SDLDecoder> *)instance {
    if (jsonDecoderInstance == nil) {
        jsonDecoderInstance = [[SDLJsonDecoder alloc] init];
    }
    return jsonDecoderInstance;
}

- (NSDictionary *)decode:(NSData *)data {
    if (data.length == 0) {
        [SDLDebugTool logInfo:@"Warning: Decoding JSON data, no JSON to decode" withType:SDLDebugType_Protocol];
        return nil;
    }

    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (error != nil) {
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Error decoding JSON data: %@", error] withType:SDLDebugType_Protocol];
        return nil;
    }

    return jsonObject;
}

@end
