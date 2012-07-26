//
//  TCTimeManager.m
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TCTimeManager.h"

@implementation TCTimeManager

static id _instance = nil;
static BOOL _willDelete = NO;

#pragma mark - Singleton Methods

+ (id)defaultManager
{
	@synchronized(self) {
		if (!_instance) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_ranges = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (!_instance) {
			_instance = [super allocWithZone:zone];
			
			return _instance;
		}
	}
	return nil;
}

+ (void)deleteManager
{
	if (_instance) {
		@synchronized(_instance) {
			_willDelete = YES;
			[_instance release];
			_instance = nil;
			_willDelete = NO;
		}
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;	
}

- (unsigned)retainCount
{
	return UINT_MAX;
}

- (oneway void)release
{
	@synchronized(self) {
		if (_willDelete) {
			[super release];
		}
	}
}

- (id)autorelease
{
	return self;
}

- (void)dealloc
{	
	[_ranges release], _ranges = nil;
	
	[super dealloc];
}

#pragma mark - Manage
- (void)beginWorking {
	[self beganFrom:0.0];
}

- (void)endWorking {
	[self endFrom:0.0];
}

- (void)beganFrom:(NSTimeInterval)interval {
	
	NSLog(@"begin");
	
	_fromTime = [[NSDate date] timeIntervalSince1970] - interval;
}

- (void)endFrom:(NSTimeInterval)interval {
	
	NSLog(@"end");
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
	[dateFormatter release];
	
	NSTimeInterval period = (([[NSDate date] timeIntervalSince1970] - interval) - _fromTime) / 60.0f;
	if (period <= 0.0) {
		return;
	}
	
	NSTimeInterval beginTime = (_fromTime - [nowDate timeIntervalSince1970]) / 60.0f;
	
	NSRange range;
	range.location = beginTime;
	range.length = period;
	
	[_ranges addObject:[NSValue valueWithRange:range]];
}

- (void)reset {
	[_ranges removeAllObjects];
}

#pragma mark - Result
- (NSArray *)timeRanges {
	return [NSArray arrayWithArray:_ranges];
}

@end
