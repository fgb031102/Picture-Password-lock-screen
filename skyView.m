//
//  skyView.m
//  04-手势解锁
//
//  Created by sky on 14-4-20.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "skyView.h"

@interface skyView ()

@property (nonatomic,strong)NSMutableArray *selectedBtnArray;
@property (nonatomic,assign)CGPoint currentPoint;

@end

@implementation skyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    CGFloat xPoint;
    CGFloat btnW = 74;
    CGFloat btnH = 74;
    CGFloat yPoint;
    int column = 3;
    CGFloat margin = (self.bounds.size.width - column * btnW) / (column + 1);
    for (int i = 0; i < 9; i++) {
        int col = i % column;
        int row = i / column;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        xPoint = margin + (margin + btnW) * col;
        btn.userInteractionEnabled = NO;//让按钮不能与用户进行交互。如果此处不设置，将不能展现点击效果
        yPoint = margin + (margin + btnH) * row;
        btn.frame = CGRectMake(xPoint, yPoint, btnW, btnH);
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.tag = i;
//        btn.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:btn];
    }
}

- (NSMutableArray *)selectedBtnArray
{
    if (_selectedBtnArray ==  nil) {
        _selectedBtnArray = [NSMutableArray array];
    }
    return _selectedBtnArray;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, pos) && btn.selected == NO) {//判断某一个点是否在一个矩形之内
            //if (btn && btn.selected == NO) {
                btn.selected = YES;
                [self.selectedBtnArray addObject:btn];
            //}
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, pos) && btn.selected == NO) {
            //if (btn && btn.selected == NO) {
                btn.selected = YES;
                [self.selectedBtnArray addObject:btn];
           // }
        }else {
            self.currentPoint = pos;
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableString *path = [NSMutableString string];
   // if ([_degelate respondsToSelector:@selector(skyView:didBtnSelectedPath:)]) {
        
        for (UIButton *btn in self.selectedBtnArray) {
            [path appendFormat:@"%d",btn.tag];
   //     }
   //     [_degelate skyView:self didBtnSelectedPath:path];
    }
    NSLog(@"path-------%@",path);
    [self.selectedBtnArray makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    [self.selectedBtnArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.selectedBtnArray.count == 0) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < self.selectedBtnArray.count; i++) {
        UIButton *btn = self.selectedBtnArray[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else {
            [path addLineToPoint:btn.center];
        }
    }
    
    if (CGPointEqualToPoint(self.currentPoint, CGPointZero) == NO) {
        [path addLineToPoint:self.currentPoint];
    }
    
    [path setLineWidth:8];
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path stroke];
//    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinBevel];
}

@end
