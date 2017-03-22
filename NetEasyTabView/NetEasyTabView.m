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

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

@interface NetEasyTabView ()<CAAnimationDelegate>
{
    CGPoint _beginPoint;
    CGPoint _lastPoint;
    CGPoint _endPoint;
    BOOL _beginIn;
    BOOL _isAnimation;
    NSInteger _currentIndex;
    CGFloat _animationOffset;
    CGFloat _lastOffset;
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
    self.backgroundColor = self.slideColor;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    for (NSString *str in self.titlesArray) {
        NSAssert([str isKindOfClass:[NSString class]], @"title must be NSString!");
        UILabel *bottomLab = [UILabel new];
        bottomLab.text = str;
        bottomLab.textColor = self.bgColor;
        bottomLab.font = self.defaultFont;
        bottomLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLab];
        bottomLab.frame = [self setTabFrameWithIndex:[self.titlesArray indexOfObject:str]];
    }
    self.midlleView = [UIView new];
    self.midlleView.userInteractionEnabled = NO;
    self.midlleView.layer.masksToBounds = YES;
    self.midlleView.backgroundColor = self.bgColor;

    [self addSubview:self.midlleView];
    for (NSString *str in self.titlesArray) {
        UILabel *topLab = [UILabel new];
        topLab.text = str;
        topLab.textColor = self.slideColor;
        topLab.font = self.defaultFont;
        topLab.textAlignment = NSTextAlignmentCenter;
        [self.midlleView addSubview:topLab];
        topLab.frame = [self setTabFrameWithIndex:[self.titlesArray indexOfObject:str]];
    }
    

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (NetEasyTabItemWidth + NetEasyTabItemMargin) * self.titlesArray.count - NetEasyTabItemMargin, NetEasyTabItemHeight);
    self.midlleView.frame = self.bounds;
    self.sliderLayer.frame = CGRectMake(0, 0, NetEasyTabItemWidth, NetEasyTabItemHeight);
    _currentIndex = 0;
    
    [self sliderMaskLayerWithOffset:0 antimation:NO];
}

-(void )sliderMaskLayerWithOffset:(CGFloat)offset antimation:(BOOL) animation{
    
    
    CGFloat radius = NetEasyTabItemHeight/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, (NetEasyTabItemWidth +NetEasyTabItemMargin) * self.titlesArray.count - NetEasyTabItemMargin, NetEasyTabItemHeight)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(NetEasyTabItemWidth - radius+offset, radius) radius:radius startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:NO]];
    [path addLineToPoint:CGPointMake(radius+offset, NetEasyTabItemHeight)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(radius +offset, radius) radius:radius startAngle:M_PI/2*3 endAngle:2.5*M_PI clockwise:NO]];
    [path addLineToPoint:CGPointMake(NetEasyTabItemWidth - radius +offset, 0)];
    [path closePath];
    
    
    _lastOffset = offset;
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.midlleView.layer.mask;
    if (!shapeLayer) {
        shapeLayer = [CAShapeLayer layer];
        
    }
    if (animation) {
        if (_isAnimation) {
            return;
        }
        self.midlleView.layer.mask = shapeLayer;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.toValue = (id)path.CGPath;
        pathAnimation.duration = 0.15;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.delegate = self;
        _isAnimation = YES;
        [shapeLayer addAnimation:pathAnimation forKey:@"moveAntimation"];
        _animationOffset = offset;
    }else{
        shapeLayer.path = path.CGPath;
        self.midlleView.layer.mask = shapeLayer;
    }
}
- (CGRect )setTabFrameWithIndex:(NSInteger)index{
    CGFloat coorDinateX = (NetEasyTabItemWidth + NetEasyTabItemMargin) * index;
    return  CGRectMake(coorDinateX, 0, NetEasyTabItemWidth, NetEasyTabItemHeight);
}

- (NSInteger)getIndexWithPoint:(CGPoint) point{
    return  point.x / (NetEasyTabItemWidth + NetEasyTabItemMargin);
}

- (void)didBeginTouchWithPoint:(CGPoint )point{
    _beginPoint = point;
    if (!CGRectContainsPoint(self.bounds, point) ) {
        return ;
    }
    NSInteger touchIndex = [self getIndexWithPoint:point];
    if (touchIndex != _currentIndex) {
        CGFloat offset = touchIndex * (NetEasyTabItemWidth + NetEasyTabItemMargin);
        [self sliderMaskLayerWithOffset: offset antimation:YES];
    }else{
        
    }
}

- (void)disEndTouchWithPoint: (CGPoint )point{
   
    NSInteger tmp = point.x / (self.frame.size.width / self.titlesArray.count);
    if (tmp > self.titlesArray.count -1) {
        tmp = self.titlesArray.count -1;
    }else if(tmp <= 0){
        tmp = 0;
    }
    CGFloat coorDinateX = tmp * (NetEasyTabItemWidth+NetEasyTabItemMargin);
    [self sliderMaskLayerWithOffset:coorDinateX antimation:YES];
    if (_currentIndex != tmp) {
            !_handle ? :_handle(tmp,self.titlesArray[tmp]);
    }
    _currentIndex = tmp;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    [self didBeginTouchWithPoint:point];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    [self disEndTouchWithPoint:point];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    CGFloat offset = point.x - _beginPoint.x + (_currentIndex *(NetEasyTabItemWidth + NetEasyTabItemMargin));

    if (offset + NetEasyTabItemWidth>= self.frame.size.width) {
        offset = self.frame.size.width - NetEasyTabItemWidth;
    }
    if (offset <= 0) {
        offset = 0;
    }
    [self sliderMaskLayerWithOffset:offset antimation:NO];

}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    [self disEndTouchWithPoint:point];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        _isAnimation = NO;
        [self sliderMaskLayerWithOffset:_animationOffset antimation:NO];
        [self.midlleView.layer.mask removeAnimationForKey:@"moveAntimation"];
    }
    
}
@end
