//  SDLEnum.h
//


@import Foundation;


@interface SDLEnum : NSObject {
	NSString* value;
}

-(instancetype) initWithValue:(NSString*) value;

-(BOOL) isEqualToEnum:(SDLEnum *) object;

@property(strong, readonly) NSString* value;

@end
