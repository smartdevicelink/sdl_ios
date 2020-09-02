//
//  SDLPrioritizedOutputCollection.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLPrioritizedObjectCollection : NSObject

/**
 * Add a new object to a push-pop collection. The object will be added in a location based on the priority passed in.
 *
 * A lower priority number is considered to be "higher". This is because this class is generally used with RPC service numbers, and lower services preempt higher ones.
 *
 * @param object   The object to be added to the priority collection
 * @param priority The priority to use when determining the location of the object in the collection. A lower number is considered a higher priority
 */
- (void)addObject:(nullable id)object withPriority:(NSInteger)priority;

/**
 * Retreive the highest priority object from the collection. This also removes the object.
 *
 * @return The highest priority object retrieved from the collection.
 */
- (nullable id)nextObject;

@end

NS_ASSUME_NONNULL_END
