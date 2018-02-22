//
//  JOImagePickerSampleTableViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOImagePickerSampleTableViewController.h"
#import "JOImagePickerViewController.h"

@interface JOImagePickerSampleTableViewController ()

@property (nonatomic, strong)   NSMutableArray*     dataSource;

@end

@implementation JOImagePickerSampleTableViewController

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

    self.title = @"ImagePicker";
}

#pragma mark - DataSource

- (void)setupData
{
    self.dataSource = [NSMutableArray new];
    
    [self.dataSource addObject:@{@"title" : @"Push single", @"method" : @"pushImagePicker", @"arrow" : @(YES)}];
    
    [self.dataSource addObject:@{@"title" : @"Present single", @"method" : @"presentImagePicker"}];
    
    [self.dataSource addObject:@{@"title" : @"Push multiple", @"method" : @"pushImagePickerMultiple", @"arrow" : @(YES)}];
    
    [self.dataSource addObject:@{@"title" : @"Present multiple", @"method" : @"presentImagePickerMultiple"}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"imagePicker";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    // Configure cell
    NSDictionary* dictionary = self.dataSource[indexPath.row];
    
    cell.textLabel.text = dictionary[@"title"];
    
    if([dictionary[@"arrow"] boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = self.dataSource[indexPath.row];
    
    NSString* methodName = dict[@"method"];
    
    if(methodName.length)
    {
        SEL selector = NSSelectorFromString(methodName);
        
        if(selector && [self respondsToSelector:selector])
        {
            // [self performSelector:selector]; // causes compiler warning, because it's a piece of shit
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        }
    }
}

#pragma mark - Actions

- (void)pushImagePicker
{
    JOImagePickerViewController* imagePicker = [JOImagePickerViewController new];
    imagePicker.title = @"ImagePicker";
    
    __weak JOImagePickerViewController* weakImagePicker = imagePicker;
    
    [imagePicker setCompletionBlock:^(BOOL isCanceled, NSArray<UIImage *> *images) {
       
        if(!isCanceled)
        {
            [self showImage:[images firstObject] navigationController:weakImagePicker.navigationController title:@"Selected Image"];
        }
        else
        {
            [weakImagePicker.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void)presentImagePicker
{
    JOImagePickerViewController* imagePicker = [JOImagePickerViewController new];
    imagePicker.title = @"ImagePicker";
    
    __weak JOImagePickerViewController* weakImagePicker = imagePicker;
    
    [imagePicker setCompletionBlock:^(BOOL isCanceled, NSArray<UIImage *> *images) {
        
        if(!isCanceled)
        {
            [self showImage:[images firstObject] navigationController:weakImagePicker.navigationController title:@"Selected Image"];
        }
        else
        {
            [weakImagePicker.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    UINavigationController* navCont = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

- (void)pushImagePickerMultiple
{
    JOImagePickerViewController* imagePicker = [JOImagePickerViewController new];
    imagePicker.title = @"ImagePicker";
    imagePicker.allowsMultipleSelection = YES;
    
    __weak JOImagePickerViewController* weakImagePicker = imagePicker;
    
    [imagePicker setCompletionBlock:^(BOOL isCanceled, NSArray<UIImage *> *images) {
        
        if(!isCanceled)
        {
            [self showImage:[images firstObject] navigationController:weakImagePicker.navigationController title:@"Show First Image"];
        }
        else
        {
            [weakImagePicker.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void)presentImagePickerMultiple
{
    JOImagePickerViewController* imagePicker = [JOImagePickerViewController new];
    imagePicker.title = @"ImagePicker";
    imagePicker.allowsMultipleSelection = YES;
    
    __weak JOImagePickerViewController* weakImagePicker = imagePicker;
    
    [imagePicker setCompletionBlock:^(BOOL isCanceled, NSArray<UIImage *> *images) {
        
        if(!isCanceled)
        {
            [self showImage:[images firstObject] navigationController:weakImagePicker.navigationController title:@"Show First Image"];
        }
        else
        {
            [weakImagePicker.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    UINavigationController* navCont = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

- (void)showImage:(UIImage*)image navigationController:(UINavigationController*)navigationController title:(NSString*)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIViewController* captureVC = [UIViewController new];
        captureVC.view.backgroundColor = [UIColor whiteColor];
        captureVC.title = title;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 300.0)];
        [captureVC.view addSubview:imageView];
        imageView.center = captureVC.view.center;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        
        [navigationController pushViewController:captureVC animated:YES];
        
    });
}

@end
