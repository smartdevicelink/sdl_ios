//
//  dispatch_timer.h
//  MobileNav
//
//  Created by Muller, Alexander (A.) on 5/12/16.
//  Copyright © 2016 Alex Muller. All rights reserved.
//

#ifndef dispatch_timer_h
#define dispatch_timer_h

#include <dispatch/dispatch.h>
#include <stdio.h>

dispatch_source_t dispatch_create_timer(double afterInterval, bool repeating, dispatch_block_t block);
void dispatch_stop_timer(dispatch_source_t timer);

#endif /* dispatch_timer_h */
