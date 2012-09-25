//
//  RootViewController.m
//  test3
//
//  Created by jiang ming on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MovieViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize controllerList;
@synthesize loginview;

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
    self.title = @"主菜单"; 
    NSMutableArray *array = [[NSMutableArray alloc] init]; 
    /* jdsy people */
    if ( JDSY_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        MovieViewController *movieViewController = [[MovieViewController alloc] initWithStyle:UITableViewStylePlain]; 
        movieViewController.title = @"ATM保洁";  
        [array addObject:movieViewController];
    
        [movieViewController release];
        
        MovieViewController *movie2ViewController = [[MovieViewController alloc] initWithStyle:UITableViewStylePlain]; 
        movie2ViewController.title = @"箱钞维修";  
        [array addObject:movie2ViewController];
        [movie2ViewController release];
    
        self.controllerList = array;
    }
    /* bank people */
    else if ( BANK_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        MovieViewController *movieViewController = [[MovieViewController alloc] initWithStyle:UITableViewStylePlain]; 
        movieViewController.title = @"坏的箱钞送出";  
        [array addObject:movieViewController];
        
        [movieViewController release];
        
        MovieViewController *movie2ViewController = [[MovieViewController alloc] initWithStyle:UITableViewStylePlain]; 
        movie2ViewController.title = @"好的箱钞接收";  
        [array addObject:movie2ViewController];
        [movie2ViewController release];
        
        self.controllerList = array;
    }
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"登入" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(leftbuttonPush:)];  
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(rightbuttonPush:)];  
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    [array release];

}
-(void)leftbuttonPush:(id)sender
{
    NSLog(@"left");
    if(LOGIN_NO == [Share_data sharedShare_data].LoginType)
    {
        // 登入界面
        self.loginview = [[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil]autorelease];
        [self presentModalViewController:loginview animated:YES];
        
    }
    else
    {
        [Share_data alertInfo:@"提示" msg:@"您已经登入,请不要连续登入！"];
    }
}
-(void)rightbuttonPush:(id)sender
{
    NSLog(@"right");
    [Share_data sharedShare_data].LoginType = LOGIN_NO;
    [Share_data sharedShare_data].barcode = nil;
    self.loginview = [[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil]autorelease];
    [self presentModalViewController:loginview animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.controllerList = nil;
    self.loginview= nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [controllerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RootTableViewCell = @"RootTableViewCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: RootTableViewCell]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: RootTableViewCell] autorelease]; 
    } 
    NSUInteger row = [indexPath row]; 
    UITableViewController *controller = [controllerList objectAtIndex:row]; 
    //这里设置每一行显示的文本为所对应的View Controller的标题
    cell.textLabel.text = controller.title;
    //accessoryType就表示每行右边的图标
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    return cell; 
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSUInteger row = [indexPath row]; 
    NSLog(@"select indexPath %d", row);
    UITableViewController *nextController = [self.controllerList objectAtIndex:row]; 
    if ( JDSY_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        switch (row) {
                //ATM保洁
            case 0:
                [Share_data sharedShare_data].ViewType = ATM_CLEAR;
                break;
                //箱钞维修
            case 1:
                [Share_data sharedShare_data].ViewType = MACHINEBOX_REPAIR;
                break;
            default:
                break;
        }
    }
    else if ( BANK_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        switch (row) {
                //坏的箱钞送出
            case 0:
                [Share_data sharedShare_data].ViewType = MACHINEBOX_BAD_SEND;
                break;
                //好的箱钞接收
            case 1:
                [Share_data sharedShare_data].ViewType = MACHINEBOX_GOOD_RECV;
                break;
            default:
                break;
        }
    }

    [self.navigationController pushViewController:nextController animated:YES];


}

@end
