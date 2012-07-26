//
//  TCTimeSelectionViewController.h
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	TimecardStateResting,
	TimecardStateWorking,
}TimecardState;

@interface TCTimeSelectionViewController : UITableViewController {
	TimecardState _state;
}

- (void)setState:(TimecardState)state;

@end
