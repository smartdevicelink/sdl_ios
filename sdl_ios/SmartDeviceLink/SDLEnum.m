//  SDLEnum.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLEnum.h>

@implementation SDLEnum

@synthesize value;

-(id) initWithValue:(NSString*) aValue {
	if (self = [super init]) {
		value = aValue;
	}
	return self;
}

-(NSString*) description {
	return value;
}

@end
