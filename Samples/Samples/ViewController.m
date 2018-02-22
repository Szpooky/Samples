//
//  ViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 21..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "ViewController.h"
#import "JOScrollViewTableViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong)   UITableView*        tableView;

@property (nonatomic, strong)   NSMutableArray*     dataSource;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Samples";
    self.navigationController.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupData];
}

#pragma mark - DataSource

- (void)setupData
{
    self.dataSource = [NSMutableArray new];
    
    [self.dataSource addObject:@{@"title" : @"ScrollView" , @"controller" : @"JOScrollViewTableViewController"}];
    
    [self.dataSource addObject:@{@"title" : @"Downloader"}];
    
    [self.dataSource addObject:@{@"title" : @"AttributedLabel"}];
    
    [self.dataSource addObject:@{@"title" : @"ImagePicker"}];
}

#pragma mark - TableView Delegate And Datasource

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - TableView Delegate And Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"element";
    
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
