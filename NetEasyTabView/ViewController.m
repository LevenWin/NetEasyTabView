//
//  ViewController.m
//  NetEasyTabView
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 Leven. All rights reserved.
//

#import "ViewController.h"
#import "NetEasyTabView.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NetEasyTabView *tabView =[[NetEasyTabView alloc] initWithFrame:CGRectMake(0, 60, KScreenWidth, 40) titles:@[@"MV",@"歌单",@"下载"] bgColor:[UIColor whiteColor] sliderColor:[UIColor darkGrayColor] clickBlock:^(NSInteger index, NSString *title) {
        
    }];
    NetEasyTabView *tabView1 =[[NetEasyTabView alloc] initWithFrame:CGRectMake(0, 120, KScreenWidth, 40) titles:@[@"MV",@"歌单",@"下载",@"666"] bgColor:[UIColor whiteColor] sliderColor:[UIColor orangeColor] clickBlock:^(NSInteger index, NSString *title) {
        
    }];
    NetEasyTabView *tabView2 =[[NetEasyTabView alloc] initWithFrame:CGRectMake(0, 180, KScreenWidth, 40) titles:@[@"MV",@"歌单"] bgColor:[UIColor whiteColor] sliderColor:[UIColor blueColor] clickBlock:^(NSInteger index, NSString *title) {
        
    }];
    [self.view addSubview:tabView];
    [self.view addSubview:tabView1];
    [self.view addSubview:tabView2];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
