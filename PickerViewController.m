//
//  PickerViewController.m
//  test3
//
//  Created by jiang ming on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController
@synthesize myPickerData;
@synthesize pick;
@synthesize myDatePicker;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  NSArray *array = [[NSArray alloc]initWithObjects:@"Hore",@"Hore2",@"Hore3", nil];
    self.myPickerData = [Share_data sharedShare_data].atm_weather;
    [pick selectRow:1 inComponent:0 animated:YES];
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

#pragma mark
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [myPickerData count];
}

#pragma  mark Picker Delegate Methods
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [myPickerData objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"select %@ index is %i", [self.myPickerData objectAtIndex:row], row);
    [Share_data sharedShare_data].selectWeather = [self.myPickerData objectAtIndex:row];
}
- (IBAction)pickerBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
