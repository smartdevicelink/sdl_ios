//  SDLJsonEncoder.m
//

#import "SDLJsonEncoder.h"

#import "SDLDebugTool.h"
#import "SDLNames.h"


@implementation SDLJsonEncoder

static NSObject<SDLEncoder> *jsonEncoderInstance;

+ (NSObject<SDLEncoder> *)instance {
    if (jsonEncoderInstance == nil) {
        jsonEncoderInstance = [[SDLJsonEncoder alloc] init];
    }
    return jsonEncoderInstance;
}

- (NSData *)encodeDictionary:(NSDictionary *)dict {
    if (dict == nil) {
        [SDLDebugTool logInfo:@"Warning: Encoding dictionary to JSON, no dictionary passed" withType:SDLDebugType_Protocol];
        return nil;
    }

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];

    if (error != nil) {
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Error encoding JSON data: %@", error] withType:SDLDebugType_Protocol];
        return nil;
    }

    return jsonData;
}

@end
