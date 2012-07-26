//
//  PieView.h
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView {
	NSMutableArray *_ranges;
}

@property (nonatomic, retain) UIColor *pieColor;
@property (nonatomic) NSUInteger divisions;

- (id)initWithOrigin:(CGPoint)origin diameter:(CGFloat)diameter;
- (void)setRanges:(NSArray *)ranges;
- (void)addRange:(NSValue *)range;

@end
