//
//  NetEasyTabView.h
//  NetEasyTabView
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 Leven. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TabItemClickHandle)(NSInteger index,NSString *title);

@interface NetEasyTabView : UIView
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic ,copy) TabItemClickHandle handle;
@property (nonatomic ,strong) UIColor *bgColor;
@property (nonatomic ,strong) UIColor *slideColor;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray clickBlock:(TabItemClickHandle)handle;
@end
