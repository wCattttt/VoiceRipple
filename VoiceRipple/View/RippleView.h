//
//  RippleView.h
//  VoiceRipple
//
//  Created by 魏唯隆 on 2018/9/10.
//  Copyright © 2018年 魏唯隆. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RippleView : UIView

- (void)startAnimation;
- (void)stopAnimation;

@property (nonatomic,assign) CGFloat kRippleYMax;   // 声波振幅大小

@end

NS_ASSUME_NONNULL_END
