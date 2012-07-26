//
//  TCPieChartViewController.h
//  Timecard
//
//  Created by Mitsuyoshi Yamazaki on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieView;

@interface TCPieChartViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *commentLabel;
@property (nonatomic, retain) IBOutlet PieView *pieView;

@end
