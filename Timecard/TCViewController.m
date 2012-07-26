//
//  TCViewController.m
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TCViewController.h"

@interface TCViewController ()
- (void)changeStateTo:(TimecardState)newState;
@end

@implementation TCViewController

@synthesize finishButton;
@synthesize stateChangeButton;
@synthesize alreadyStateChangedButton;

#pragma mark - Lifecycle
- (void)dealloc {
	self.finishButton = nil;
	self.stateChangeButton = nil;
	self.alreadyStateChangedButton = nil;
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Behavior
- (IBAction)finished:(id)sender {
	_currentState = TimecardStateResting;
}

- (IBAction)changeState:(id)sender {
	
	switch (_currentState) {
		case TimecardStateWorking:
			[self changeStateTo:TimecardStateResting];
			break;
			
		case TimecardStateResting:	
		default:
			[self changeStateTo:TimecardStateWorking];
			break;
	}
}

- (IBAction)alreadyChanged:(id)sender {
	
}

- (void)changeStateTo:(TimecardState)newState {
	
	switch (newState) {
		case TimecardStateWorking:
			[self.stateChangeButton setTitle:@"終業" forState:UIControlStateNormal];
			[self.alreadyStateChangedButton setTitle:@"終業してた" forState:UIControlStateNormal];
			break;
			
		case TimecardStateResting:	
		default:
			[self.stateChangeButton setTitle:@"始業" forState:UIControlStateNormal];
			[self.alreadyStateChangedButton setTitle:@"始業してた" forState:UIControlStateNormal];
			break;
	}
	
	_currentState = newState;
}

@end
