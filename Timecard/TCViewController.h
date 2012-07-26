//
//  TCViewController.h
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCTimeSelectionViewController.h"

@interface TCViewController : UIViewController {
	TimecardState _currentState;
}

@property (nonatomic, retain) IBOutlet UIButton *finishButton;
@property (nonatomic, retain) IBOutlet UIButton *stateChangeButton;
@property (nonatomic, retain) IBOutlet UIButton *alreadyStateChangedButton;

- (IBAction)changeState:(id)sender;

@end
