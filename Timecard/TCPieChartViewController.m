//
//  TCPieChartViewController.m
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TCPieChartViewController.h"

#import "TCTimeManager.h"
#import "PieView.h"

@interface TCPieChartViewController ()

@end

@implementation TCPieChartViewController

@synthesize pieView;
@synthesize commentLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	self.commentLabel = nil;
    self.pieView = nil;
	
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.pieView.pieColor = [UIColor darkGrayColor];
	self.pieView.divisions = 24;
	
	TCTimeManager *manager = [TCTimeManager defaultManager];
	NSArray *ranges = manager.timeRanges;
	[self.pieView setRanges:ranges];
	
	[manager reset];
	
	NSUInteger time = 0;	// time [minutes]
	for (NSValue *value in ranges) {
		NSRange range = value.rangeValue;
		time += range.length;
	}
	
	NSString *half = ((time % 60) / 25 == 0) ? @"" : @"半";
	NSString *hour = (time / 60 == 0) ? @"半時間" : [NSString stringWithFormat:@"%d時間%@", time / 60, half];
	
	self.commentLabel.text = [NSString stringWithFormat:@"今日は%@はたらきました。おつかれさま", hour];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
