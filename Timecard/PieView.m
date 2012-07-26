//
//  PieView.m
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PieView.h"

static const float patternSize = 16.0f;

@interface PieView ()

- (void)initialize;
- (void)drawDial:(CGContextRef)context rect:(CGRect)dialRect;
- (void)drawDivision:(CGContextRef)context rect:(CGRect)dialRect;
- (void)drawSector:(CGContextRef)context rect:(CGRect)dialRect;
void drawPattern(void* info, CGContextRef context);

@end

@implementation PieView

@synthesize pieColor = _pieColor;
@synthesize divisions;

#pragma mark - Accessor
- (void)setPieColor:(UIColor *)newValue {

	if (_pieColor != newValue) {
		[_pieColor release], _pieColor = nil;
		_pieColor = (newValue == nil) ? [[UIColor alloc] initWithWhite:1.0f alpha:1.0f] : [newValue retain];
	}
}

#pragma mark - Lifecycle
- (id)initWithOrigin:(CGPoint)origin diameter:(CGFloat)diameter {
	self = [super initWithFrame:CGRectMake(origin.x, origin.y, diameter, diameter)];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	self.backgroundColor = [UIColor whiteColor];
	self.pieColor = [UIColor blackColor];
	_ranges = [[NSMutableArray alloc] initWithCapacity:0];
	self.divisions = 0;
}

- (void)dealloc
{
    [_pieColor release], _pieColor = nil;
	[_ranges release], _ranges = nil;
	
    [super dealloc];
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGColorRef color = self.pieColor.CGColor;
	CGContextSetStrokeColorWithColor(context, color);
	CGContextSetFillColorWithColor(context, color);
	
	CGRect dialRect = self.bounds;
	
	if (dialRect.size.width > dialRect.size.height) {
		dialRect.origin.x = (dialRect.size.width - dialRect.size.height) / 2;
		dialRect.size.width = dialRect.size.height;
	}
	if (dialRect.size.width < dialRect.size.height) {
		dialRect.origin.y = (dialRect.size.height - dialRect.size.width) / 2;
		dialRect.size.height = dialRect.size.width;
	}
	
	CGFloat lineWidth = 2.0f;
	CGContextSetLineWidth(context, lineWidth);
	
	CGFloat margin = lineWidth / 2.0f;
	dialRect.origin.x += margin;
	dialRect.origin.y += margin;
	dialRect.size.width -= margin * 2.0f;
	dialRect.size.height -= margin * 2.0f;
	
	[self drawDial:context rect:dialRect];
	[self drawDivision:context rect:dialRect];
	[self drawSector:context rect:dialRect];
}

- (void)drawDial:(CGContextRef)context rect:(CGRect)dialRect {
		
	CGContextStrokeEllipseInRect(context, dialRect);
}

- (void)drawDivision:(CGContextRef)context rect:(CGRect)dialRect {

	CGPoint points[2];
	CGFloat radius = dialRect.size.width / 2.0f;
	CGFloat lineLength = radius / 20.0f;
	CGPoint centerPoint;
	centerPoint.x = dialRect.origin.x + (dialRect.size.width / 2.0f);
	centerPoint.y = dialRect.origin.y + (dialRect.size.height / 2.0f);

	for (int i = 0; i < self.divisions; i++) {
		CGFloat radian = (2 * M_PI) * i / self.divisions;
		points[0] = CGPointMake(centerPoint.x + radius * sinf(radian), centerPoint.y - radius * cosf(radian));
		points[1] = CGPointMake(centerPoint.x + (radius - lineLength) * sinf(radian), centerPoint.y - (radius - lineLength) * cosf(radian));
		CGContextStrokeLineSegments(context, points, 2);
	}	
}

- (void)drawSector:(CGContextRef)context rect:(CGRect)dialRect {
	
	static const CGPatternCallbacks callbacks = { 0, &drawPattern, NULL};
	
	CGColorRef color = self.pieColor.CGColor;
	CGPatternRef pattern = CGPatternCreate(&color,
										   CGRectMake(0.0f, 0.0f, patternSize, patternSize),
										   CGAffineTransformIdentity,
										   patternSize - 1.0f, 
										   patternSize - 1.0f,
										   kCGPatternTilingNoDistortion,
										   true,
										   &callbacks);
	
	CGPoint starPoints[4];
	starPoints[0] = CGPointMake(0, 0);
	starPoints[1] = CGPointMake(0, 100);
	starPoints[2] = CGPointMake(100, 100);
	starPoints[3] = CGPointMake(100, 0);
	
	CGContextSaveGState (context);
	
	CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);	
	CGContextSetFillColorSpace(context, patternSpace);
	CGColorSpaceRelease (patternSpace);
	
	CGFloat alpha = 1;
	CGFloat radius = dialRect.size.width / 2.0f;
	CGPoint centerPoint;
	centerPoint.x = dialRect.origin.x + (dialRect.size.width / 2.0f);
	centerPoint.y = dialRect.origin.y + (dialRect.size.height / 2.0f);

	for (NSValue *value in _ranges) {
		NSRange range = value.rangeValue;
		CGFloat beginPoint = (((float)range.location * (M_PI * 2)) / (24.0f * 60.0f));
		CGFloat endPoint = (((float)(range.location + range.length) * (M_PI * 2)) / (24.0f * 60.0f));
		
		CGContextSetFillPattern(context, pattern, &alpha);
		CGContextBeginPath(context);
		CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, beginPoint - M_PI_2, endPoint - M_PI_2, 0);
		CGContextAddLineToPoint(context, centerPoint.x, centerPoint.y);
		CGContextClosePath(context);
		CGContextFillPath(context);

		CGContextBeginPath(context);
		CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, beginPoint - M_PI_2, endPoint - M_PI_2, 0);
		CGContextAddLineToPoint(context, centerPoint.x, centerPoint.y);
		CGContextClosePath(context);
		CGContextStrokePath(context);
	}
		
	CGContextRestoreGState(context);
	CGPatternRelease(pattern);
}


#pragma mark - Set Range
- (void)setRanges:(NSArray *)ranges {
	[_ranges removeAllObjects];
	[_ranges addObjectsFromArray:ranges];
}

- (void)addRange:(NSValue *)range {
	[_ranges addObject:range];
}

#pragma mark - Pattern
void drawPattern(void* info, CGContextRef context) {
	
	CGColorRef *color = info;
	CGPoint points[2];
	
	CGContextSetLineWidth(context, 1.5f);
	CGContextSetLineCap(context, kCGLineCapButt);
	CGContextSetStrokeColorWithColor(context, *color);
	
	points[0] = CGPointMake(patternSize, 0);
	points[1] = CGPointMake(0, patternSize);
	CGContextStrokeLineSegments(context, points, 2);
}


@end
