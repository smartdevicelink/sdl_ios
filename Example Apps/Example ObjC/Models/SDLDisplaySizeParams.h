//
//  SDLDisplaySizeModel.h
//  TestScaleApp
//
//  Created by Leonid Lokhmatov on 5/24/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

@interface SDLDisplaySizeParams : NSObject

@property (assign, nonatomic) CGSize displaySize;
@property (assign, nonatomic) float scale;

+ (instancetype)displaySizeParamsWithSize:(CGSize)size scale:(float)scale;

- (CGRect)makeDisplayRect;

- (CGRect)appViewportFrame;

@end

NS_ASSUME_NONNULL_END
