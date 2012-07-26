//
//  TCTimeSelectionViewController.m
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TCTimeSelectionViewController.h"

#import "TCTimeManager.h"

@interface TCTimeSelectionViewController ()

@end

@implementation TCTimeSelectionViewController

#pragma mark - Accessor
- (void)setState:(TimecardState)state {
	_state = state;
}

#pragma mark - Lifecycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		return;
	}
	
	NSTimeInterval time = 0.0;
	
	switch (indexPath.row) {
		case 1:
			time = 15 * 60;
			break;
			
		case 2:
			time = 30 * 60;
			break;
			
		case 3:
			time = 1 * 60 * 60;
			break;
			
		case 4:
			time = 2 * 60 * 60;
			break;
			
		default:
			break;
	}
	
	TCTimeManager *manager = [TCTimeManager defaultManager];
	
	switch (_state) {
		case TimecardStateWorking:
			[manager endFrom:time];
			break;
			
		case TimecardStateResting:	
		default:
			[manager beganFrom:time];
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

@end
