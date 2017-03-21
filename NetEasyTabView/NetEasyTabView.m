//
//  NetEasyTabView.m
//  NetEasyTabView
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 Leven. All rights reserved.
//

#import "NetEasyTabView.h"

#define NetEasyTabItemHeight 34
#define NetEasyTabItemWidth 65
#define NetEasyTabItemMargin 4
/*
 
 为什么tab移动不够迅速呢？估计是因为mask的问题有知道的童鞋请告知
 
*/


@interface NetEasyTabView ()
{
    CGPoint _beginPoint;
    CGPoint _lastPoint;
    CGPoint _endPoint;
    BOOL _beginIn;
    NSInteger _currentIndex;
}

@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIView *midlleView;
@property (nonatomic, strong) CALayer *sliderLayer;
@end
@implementation NetEasyTabView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray clickBlock:(TabItemClickHandle)handle{
    if (self= [super initWithFrame:frame]) {
        self.handle = handle;
        self.bgColor = [UIColor orangeColor];
        self.slideColor = [UIColor whiteColor];
        self.defaultFont = [UIFont systemFontOfSize:17];
        self.titlesArray = titlesArray;
    }
    return self;
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    [self setupUI];
}
- (void)setupUI{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = NetEasyTabItemHeight / 2.0;
    self.layer.borderColor = self.slideColor.CGColor;
    self.layer.borderWidth = 0.7;
    self.backgroundColor = self.bgColor;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    for (NSString *str in self.titlesArray) {
        NSAssert([str isKindOfClass:[NSString class]], @"title must be NSString!");
        UILabel *bottomLab = [UILabel new];
        bottomLab.text = str;
        bottomLab.textColor = self.slideColor;
        bottomLab.font = self.defaultFont;
        bottomLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLab];
        bottomLab.frame = [self setTabFrameWithIndex:[self.titlesArray indexOfObject:str]];
    }
    self.midlleView = [UIView new];
    self.midlleView.userInteractionEnabled = NO;
    self.midlleView.layer.masksToBounds = YES;
    self.midlleView.backgroundColor = self.slideColor;

    [self addSubview:self.midlleView];
    for (NSString *str in self.titlesArray) {
        UILabel *topLab = [UILabel new];
        topLab.text = str;
        topLab.textColor = self.bgColor;
        topLab.font = self.defaultFont;
        topLab.textAlignment = NSTextAlignmentCenter;
        [self.midlleView addSubview:topLab];
        topLab.frame = [self setTabFrameWithIndex:[self.titlesArray indexOfObject:str]];
    }
    
    self.sliderLayer = [CALayer new];
    self.sliderLayer.masksToBounds = YES;
    self.sliderLayer.backgroundColor = self.bgColor.CGColor;
    self.sliderLayer.cornerRadius = NetEasyTabItemHeight / 2;
    self.midlleView.layer.mask = self.sliderLayer;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (NetEasyTabItemWidth + NetEasyTabItemMargin) * self.titlesArray.count - NetEasyTabItemMargin, NetEasyTabItemHeight);
    self.midlleView.frame = self.bounds;
    self.sliderLayer.frame = CGRectMake(0, 0, NetEasyTabItemWidth, NetEasyTabItemHeight);
    _currentIndex = 0;
    [self layoutIfNeeded];
    [self.midlleView layoutIfNeeded];

}
- (CGRect )setTabFrameWithIndex:(NSInteger)index{
    CGFloat coorDinateX = (NetEasyTabItemWidth + NetEasyTabItemMargin) * index;
    return  CGRectMake(coorDinateX, 0, NetEasyTabItemWidth, NetEasyTabItemHeight);
}

- (void)didBeginTouchWithPoint:(CGPoint )point{
    _beginPoint = point;
    if (CGRectContainsPoint(self.bounds, point) ) {
        _beginIn = YES;
    }
    if (!CGRectContainsPoint(self.sliderLayer.frame, _beginPoint) &&CGRectContainsPoint(self.bounds, point) ) {
        CGRect frame = self.sliderLayer.frame;
        CGFloat x = point.x -frame.size.width/2;
        if (x + NetEasyTabItemWidth > self.frame.size.width) {
            x = self.frame.size.width - NetEasyTabItemWidth;
        }
        [UIView animateWithDuration:0.15 animations:^{
            self.sliderLayer.frame = CGRectMake(x, 0, frame.size.width, frame.size.height);
        }];
    }
}

- (void)disEndTouchWithPoint: (CGPoint )point{
    _endPoint = point;
    CGRect frame = self.sliderLayer.frame;
    CGFloat centerX = frame.origin.x + frame.size.width / 2;
    NSInteger tmp = centerX / (self.frame.size.width / self.titlesArray.count);
    CGFloat coorDinateX = tmp * (NetEasyTabItemWidth+NetEasyTabItemMargin);
    [UIView animateWithDuration:0.15 animations:^{
        self.sliderLayer.frame = CGRectMake(coorDinateX,0 , NetEasyTabItemWidth, NetEasyTabItemHeight);
    }completion:^(BOOL finished) {
        if (_currentIndex != tmp) {
            !_handle ? :_handle(tmp,self.titlesArray[tmp]);
            _currentIndex = tmp;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    NSLog(@"  begin  ---%@",NSStringFromCGPoint(point));
    [self didBeginTouchWithPoint:point];

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    NSLog(@"  end  ---%@",NSStringFromCGPoint(point));

    [self disEndTouchWithPoint:point];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    NSLog(@"  move  ---%@",NSStringFromCGPoint(point));
    CGRect frame = self.sliderLayer.frame;
    CGFloat x = point.x -frame.size.width/2;
    if (x + NetEasyTabItemWidth > self.frame.size.width) {
        x = self.frame.size.width - NetEasyTabItemWidth;
    }
    if (x < 0) {
        x = 0;
    }
    self.sliderLayer.frame = CGRectMake(x, 0, frame.size.width, frame.size.height);

}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.frame, point)) {
        [self disEndTouchWithPoint:point];
    }
}
@end
