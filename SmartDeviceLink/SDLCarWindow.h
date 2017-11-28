//
//  SDLCarWindow.h
//  Projection
//
//  Created by Muller, Alexander (A.) on 10/6/16.
//  Copyright © 2016 Ford Motor Company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLCarWindow : NSObject

/**
 *  View Controller that will be streamed.
 */
@property (strong, nonatomic, nullable) UIViewController *rootViewController;

@end

NS_ASSUME_NONNULL_END
