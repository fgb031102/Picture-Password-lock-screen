//
//  skyView.h
//  04-手势解锁
//
//  Created by sky on 14-4-20.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class skyView;
@protocol skyViewDelegate <NSObject>

- (void)skyView:(skyView *)view didBtnSelectedPath:(NSString *)path;

@end

@interface skyView : UIView

@property (nonatomic,weak)id <skyViewDelegate>degelate;

@end
