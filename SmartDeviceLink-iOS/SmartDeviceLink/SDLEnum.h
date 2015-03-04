//  SDLEnum.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

@import Foundation;


@interface SDLEnum : NSObject {
	NSString* value;
}

-(id) initWithValue:(NSString*) value;

@property(strong, readonly) NSString* value;

@end
