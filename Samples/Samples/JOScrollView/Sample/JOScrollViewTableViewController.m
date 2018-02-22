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
    
    UIBarButtonItem* infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleDone target:self action:@selector(info:)];
    [self.navigationItem setRightBarButtonItems:@[infoButton] animated:YES];
}

// iOS 11.2 bug workaround (related to the UIBarButtonItem highlight)
// https://stackoverflow.com/questions/47805224/uibarbuttonitem-will-be-always-highlight-when-i-click-it
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

#pragma mark - Actions

- (void)info:(UIBarButtonItem*)sender
{
    UIViewController* infoVC = [UIViewController new];
    infoVC.view.backgroundColor = [UIColor whiteColor];
    infoVC.title = @"ScrollView Info";
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectInset(self.view.frame, 20.0, 100.0)];
    textView.textColor = [UIColor blackColor];
    textView.editable = NO;
    [infoVC.view addSubview:textView];
    [self.navigationController pushViewController:infoVC animated:YES];
    
    textView.text = @"This is the list of some implemtations of the scrollview. They're related to the JOScrollViewTransformator subclasses. These are different implementation of the scrollView engine. The most of them are just note for me.";
}

#pragma mark - DataSource

- (void)setupData
{
    self.dataSource = [NSMutableArray new];
    
    [self.dataSource addObject:@{@"title" : @"Old", @"controller" : @"JOScrollViewOldViewController"}];
    
    [self.dataSource addObject:@{@"title" : @"Simple", @"controller" : @"JOScrollViewSimpleViewController"}];
    
    [self.dataSource addObject:@{@"title" : @"Masked Simple", @"controller" : @""}];
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
    
    if(!controllerClass.length)
    {
        controllerClass = @"UIViewController";
    }
    
    UIViewController* controller = [[NSClassFromString(controllerClass) alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
