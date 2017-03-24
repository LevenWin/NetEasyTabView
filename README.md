# NetEasyTabView
![](https://github.com/LevenWin/NetEasyTabView/blob/master/Untitled.gif) 

<pre><code>   
NetEasyTabView *tabView =[[NetEasyTabView alloc] initWith
         Frame:CGRectMake(20, 100, 0, 0) 
         titles:@[@"单曲",@"节目",@"MV"] 
         clickBlock:^(NSInteger index, NSString *title) {
            NSLog(@"%@  %lu",title,index);
         }];
    
    
    </code></pre>

