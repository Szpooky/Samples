//
//  JOScrollViewTableViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 21..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOScrollViewTableViewController.h"

@interface JOScrollViewTableViewController ()

@property (nonatomic, strong)   NSMutableArray*     dataSource;

@end

@implementation JOScrollViewTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        [self setupData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ScrollView";
}

#pragma mark - DataSource

- (void)setupData
{
    self.dataSource = [NSMutableArray new];
    
    [self.dataSource addObject:@{@"title" : @"Old", @"controller" : @"JOScrollViewOldViewController"}];
    
    [self.dataSource addObject:@{@"title" : @"Simple", @"controller" : @"JOScrollViewSimpleViewController"}];
}


#pragma mark - Table view data source

#pragma mark - TableView Delegate And Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"scrollView";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = self.dataSource[indexPath.row];
    
    NSString* controllerClass = dict[@"controller"];
    
    if(!controllerClass)
    {
        controllerClass = @"UIViewController";
    }
    
    UIViewController* controller = [[NSClassFromString(controllerClass) alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
