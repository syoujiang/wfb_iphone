//
//  SelectViewController.h
//  test3
//
//  Created by jiang ming on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Share_data.h"

@interface SelectViewController : UITableViewController
@property (strong, nonatomic) NSArray *movieList;
-(void)switchChanged:(UISwitch *)sender;
@end
