# NetEasyTabView

### 模仿网易云音乐的tab切换

![](https://github.com/LevenWin/NetEasyTabView/blob/master/NetEasyTabView/Untitled.gif) 

```
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
```

