//
//  ViewController.m
//  LRImageScrollViewDemo
//
//  Created by lirong on 16/7/8.
//  Copyright © 2016年 lirong. All rights reserved.
//

#import "ViewController.h"
#import "LRImageScrollView.h"
#import "ContentViewController.h"
@interface ViewController () <UIScrollViewDelegate,LRImageScrollViewDelegate >
@property (strong, nonatomic) LRImageScrollView *imageSV;
@property (strong, nonatomic) NSArray *imageNameArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageNameArray = [NSArray arrayWithObjects:@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg",  nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageSV = [[LRImageScrollView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 220) andImageNameArray:self.imageNameArray];
    self.imageSV.delegate = self;
    [self.view addSubview:self.imageSV];
    [self.imageSV setPageControlMode:PAGECONTROLMODEL_CENTER];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 200, 100)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = @"点击图片进行页面跳转";
    [self.view addSubview:label];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.imageSV addTimer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.imageSV removeTimer];
}

#pragma mark - LRImageScrollViewDelegate
-(void)clickImageAtIndex:(int)index
{
    NSLog(@"点击了第%d张图",index+1);
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    contentVC.index = index + 1;
    [self.navigationController pushViewController:contentVC animated:NO];
}

@end
