//
//  ViewController.m
//  NetEasyTabView
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 Leven. All rights reserved.
//

#import "ViewController.h"
#import "NetEasyTabView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NetEasyTabView *tabView =[[NetEasyTabView alloc] initWithFrame:CGRectMake(20, 100, 0, 0) titles:@[@"单曲",@"节目",@"MV"] clickBlock:^(NSInteger index, NSString *title) {
        NSLog(@"%@  %lu",title,index);
    }];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tabView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
