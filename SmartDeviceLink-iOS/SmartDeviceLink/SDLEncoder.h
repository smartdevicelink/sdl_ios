//  SDLEncoder.h
//


#import <Foundation/Foundation.h>

@protocol SDLEncoder <NSObject>

- (NSData *)encodeDictionary:(NSDictionary *)dict;

@end
