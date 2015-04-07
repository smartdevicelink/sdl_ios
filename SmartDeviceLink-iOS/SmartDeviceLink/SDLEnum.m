//  SDLEnum.m
//


#import "SDLEnum.h"

@implementation SDLEnum

@synthesize value;

-(instancetype) initWithValue:(NSString*) aValue {
	if (self = [super init]) {
		value = aValue;
	}
	return self;
}

-(NSString*) description {
	return value;
}

@end
