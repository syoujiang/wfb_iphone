//
//  SelectViewController.m
//  test3
//
//  Created by jiang ming on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController
@synthesize movieList;

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
  //  NSArray *array = [[NSArray alloc] initWithObjects:@"肖申克的救赎", @"教父", @"惊魂记", @"美好人生", nil];
    if (ARRAY_EQUIP == [Share_data sharedShare_data].arrayType) {
        self.movieList = [Share_data sharedShare_data].atm_equip_state;
    }
    else if (ARRAY_SAFEWARN == [Share_data sharedShare_data].arrayType) {
        self.movieList = [Share_data sharedShare_data].atm_safewarn;
    }
    else if (ARRAY_FAIL_JUDGE == [Share_data sharedShare_data].arrayType) {
        self.movieList = [Share_data sharedShare_data].machine_failjudge;
    }
    else if (ARRAY_REPAIR_TYPE == [Share_data sharedShare_data].arrayType) {
        self.movieList = [Share_data sharedShare_data].machine_repairtype;
    }
    else if (ARRAY_REPLACE_NUM == [Share_data sharedShare_data].arrayType) {
        self.movieList = [Share_data sharedShare_data].machine_replacenum;
    }

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.movieList = nil;
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
    return [movieList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RootTableViewCell = @"RootTableViewCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: RootTableViewCell]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: RootTableViewCell]autorelease]; 
    } 
    NSUInteger row = [indexPath row]; 
    NSString *movieTitle = [movieList objectAtIndex:row]; 
    
    //这里设置每一行显示的文本为所对应的View Controller的标题
 //   NSLog(@"%@",controller.title);

    cell.textLabel.text = movieTitle;
    UISwitch *aSwitch= [[UISwitch alloc]initWithFrame:CGRectMake(220,8,70,40)];
    NSLog(@" view type is %d",[Share_data sharedShare_data].arrayType);
    if(ARRAY_EQUIP == [Share_data sharedShare_data].arrayType)
    {
        for(NSString *comString in [Share_data sharedShare_data].selectStatuesString) 
        {
            if([comString isEqualToString:movieTitle])
            {
                aSwitch.on = YES;        
            }
        }
    }
    else if(ARRAY_SAFEWARN == [Share_data sharedShare_data].arrayType) 
    {
        for(NSString *comString in [Share_data sharedShare_data].selectSafeString) 
        {
            if([comString isEqualToString:movieTitle])
            {
                aSwitch.on = YES;        
            }
        }
    }
    else if(ARRAY_FAIL_JUDGE == [Share_data sharedShare_data].arrayType) 
    {
        for(NSString *comString in [Share_data sharedShare_data].machine_failjudge_select) 
        {
            if([comString isEqualToString:movieTitle])
            {
                aSwitch.on = YES;        
            }
        }
    }
    else if(ARRAY_REPLACE_NUM == [Share_data sharedShare_data].arrayType) 
    {
        for(NSString *comString in [Share_data sharedShare_data].machine_replacenum_select) 
        {
            if([comString isEqualToString:movieTitle])
            {
                aSwitch.on = YES;        
            }
        }
    }
    
    aSwitch.tag = row;
    [aSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:aSwitch];
    [aSwitch release];
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
     [detailViewController release];
     */
}
-(void)switchChanged:(UISwitch *)sender
{
    Boolean remainded = sender.on;
    NSLog(@"%i %d",remainded,sender.tag);
    NSLog(@"%d",[Share_data sharedShare_data].arrayType);
    if(ARRAY_EQUIP == [Share_data sharedShare_data].arrayType)
    {
        if([Share_data sharedShare_data].selectStatuesString == nil)
        {
            [Share_data sharedShare_data].selectStatuesString = [NSMutableArray arrayWithCapacity:20];
        }
        /* add */
        if(true == remainded)
        {
            NSLog(@"%@",[movieList objectAtIndex:sender.tag]);
            [[Share_data sharedShare_data].selectStatuesString addObject:[movieList objectAtIndex:sender.tag]];
        }
        else    {
            [[Share_data sharedShare_data].selectStatuesString removeObject:[movieList objectAtIndex:sender.tag]];        
        }
    }
    else if(ARRAY_SAFEWARN == [Share_data sharedShare_data].arrayType) 
    {
        if([Share_data sharedShare_data].selectSafeString == nil)
        {
            [Share_data sharedShare_data].selectSafeString = [NSMutableArray arrayWithCapacity:20];
        }
        /* add */
        if(true == remainded)
        {
            NSLog(@"%@",[movieList objectAtIndex:sender.tag]);
            [[Share_data sharedShare_data].selectSafeString addObject:[movieList objectAtIndex:sender.tag]];
        }
        else    {
            [[Share_data sharedShare_data].selectSafeString removeObject:[movieList objectAtIndex:sender.tag]];        
        }
    }
    else if(ARRAY_FAIL_JUDGE == [Share_data sharedShare_data].arrayType) 
    {
        if([Share_data sharedShare_data].machine_failjudge_select == nil)
        {
            [Share_data sharedShare_data].machine_failjudge_select = [NSMutableArray arrayWithCapacity:20];
        }
        /* add */
        if(true == remainded)
        {
            NSLog(@"%@",[movieList objectAtIndex:sender.tag]);
            [[Share_data sharedShare_data].machine_failjudge_select addObject:[movieList objectAtIndex:sender.tag]];
        }
        else    {
            [[Share_data sharedShare_data].machine_failjudge_select removeObject:[movieList objectAtIndex:sender.tag]];        
        }
    }
    else if(ARRAY_REPLACE_NUM == [Share_data sharedShare_data].arrayType) 
    {
        if([Share_data sharedShare_data].machine_replacenum_select == nil)
        {
            [Share_data sharedShare_data].machine_replacenum_select = [NSMutableArray arrayWithCapacity:20];
        }
        /* add */
        if(true == remainded)
        {
            NSLog(@"%@",[movieList objectAtIndex:sender.tag]);
            [[Share_data sharedShare_data].machine_replacenum_select addObject:[movieList objectAtIndex:sender.tag]];
        }
        else    {
            [[Share_data sharedShare_data].machine_replacenum_select removeObject:[movieList objectAtIndex:sender.tag]];        
        }
    }
}

@end
