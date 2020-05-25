//
//  SDLDisplaySizeModel.m
//  TestScaleApp
//
//  Created by Leonid Lokhmatov on 5/24/20.
//  Copyright © 2018 Luxoft. All rights reserved
//


#import "SDLDisplaySizeParams.h"
#import "SDLStreamingVideoScaleManager.h"

@implementation SDLDisplaySizeParams

+ (instancetype)displaySizeParamsWithSize:(CGSize)size scale:(float)scale {
    SDLDisplaySizeParams* displaySize = [self new];
    displaySize.displaySize = size;
    displaySize.scale = scale;
    return displaySize;
}

- (CGRect)makeDisplayRect {
    return CGRectMake(0, 0, self.displaySize.width, self.displaySize.height);
}

- (CGRect)appViewportFrame {
    // Screen capture in the CarWindow API only works if the width and height are integer values
    return (CGRect){CGPointZero, [SDLStreamingVideoScaleManager scale:self.scale size:self.displaySize]};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> {%2.1fx%2.1f, scale:%2.2f}", NSStringFromClass(self.class), self,
            self.displaySize.width, self.displaySize.height, self.scale];
}

@end
