//
//  SDLPrioritizedOutputCollection.h
//  AppLink
//

#import <Foundation/Foundation.h>

@interface SDLPrioritizedObjectCollection : NSObject

- (void)addObject:(id)object withPriority:(NSInteger)priority;
- (id)nextObject;

@end
