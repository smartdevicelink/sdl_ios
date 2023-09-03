//
//  dispatch_timer.c
//  MobileNav
//
//  Created by Muller, Alexander (A.) on 5/12/16.
//  Copyright © 2016 Alex Muller. All rights reserved.
//

#include "dispatch_timer.h"

dispatch_source_t dispatch_create_timer(double afterInterval, bool repeating, dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                       0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0,
                                                     0,
                                                     queue);
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterInterval * NSEC_PER_SEC)),
                              (uint64_t)(afterInterval * NSEC_PER_SEC),
                              (1ull * NSEC_PER_SEC) / 10);
    dispatch_source_set_event_handler(timer, ^{
        if (!repeating) {
            dispatch_stop_timer(timer);
        }
        if (block) {
            block();
        }
    });
    dispatch_resume(timer);

    return timer;
}

void dispatch_stop_timer(dispatch_source_t timer) {
    dispatch_source_set_event_handler(timer, NULL);
    dispatch_source_cancel(timer);
}
