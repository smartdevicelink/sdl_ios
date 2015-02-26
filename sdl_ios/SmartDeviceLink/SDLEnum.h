//  SDLEnum.h
//
//  

#import <Foundation/Foundation.h>

@interface SDLEnum : NSObject {
	NSString* value;
}

-(id) initWithValue:(NSString*) value;

@property(strong, readonly) NSString* value;

@end
