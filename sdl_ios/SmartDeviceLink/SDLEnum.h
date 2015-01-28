//  SDLEnum.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

@interface SDLEnum : NSObject {
	NSString* value;
}

-(id) initWithValue:(NSString*) value;

- (BOOL)isEqualToEnum:(SDLEnum *)object;

@property(strong, readonly) NSString* value;

@end
