//  SDLEnum.h
//


@import Foundation;


@interface SDLEnum : NSObject {
	NSString* value;
}

-(id) initWithValue:(NSString*) value;

@property(strong, readonly) NSString* value;

@end
