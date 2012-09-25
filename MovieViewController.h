//
//  MovieViewController.h
//  test3
//
//  Created by jiang ming on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Share_data.h"
#import "ZBarSDK.h"
#import "SelectViewController.h"
#import "PickerViewController.h"
#import "GCDAsyncSocket.h"

@interface MovieViewController : UITableViewController<ZBarReaderDelegate, UIActionSheetDelegate>
{
    NSString *rep_code;
    NSArray  *rep_err_judge;
    NSArray  *rep_replace_no;
    NSArray  *rep_result;
}

@property (strong, nonatomic) NSArray *movieList;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *decLabel;

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dec;
@property (strong, nonatomic) yUIAlertViewWithAI *myAlert;
@property (copy, nonatomic) NSString *rep_code;
@property (strong, nonatomic) NSArray *rep_err_judge;
@property (strong, nonatomic) NSArray *rep_replace_no;
@property (strong, nonatomic) NSArray *rep_result;
@end
