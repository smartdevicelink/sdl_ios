//  SDLEnum.h
//


@import Foundation;


@interface SDLEnum : NSObject {
	NSString* value;
}

-(instancetype) initWithValue:(NSString*) value;

@property(strong, readonly) NSString* value;

@end
