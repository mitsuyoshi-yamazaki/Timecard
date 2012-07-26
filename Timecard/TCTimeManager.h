//
//  TCTimeManager.h
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCTimeManager : NSObject {
	NSMutableArray *_ranges;
	NSTimeInterval _fromTime;
}

+ (id)defaultManager;
+ (void)deleteManager;

- (void)beginWorking;
- (void)endWorking;
- (void)beganFrom:(NSTimeInterval)interval;
- (void)endFrom:(NSTimeInterval)interval;
- (void)reset;

- (NSArray *)timeRanges;
- (void)store;

@end
