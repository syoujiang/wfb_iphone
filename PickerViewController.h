//
//  PickerViewController.h
//  test3
//
//  Created by jiang ming on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Share_data.h"


@interface PickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic,retain) IBOutlet UIPickerView *pick;
@property(nonatomic,retain) IBOutlet UIDatePicker *myDatePicker;
@property(strong, nonatomic) NSArray *myPickerData;
- (IBAction)pickerBack:(id)sender;
//- (IBAction)pickerSelect:(id)sender;

@end
