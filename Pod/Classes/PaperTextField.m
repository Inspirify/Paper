//
//  PaperTextField.m
//  Pods
//
//  Created by Tom Li on 7/7/14.
//
//

#import "PaperTextField.h"
#import <UIKit+Material/UIFont+Material.h>
#import <UIKit+Material/UIColor+Material.h>

#define kDefaultTextFont [UIFont robotoMediumFontOfSize:18.f]
#define kDefaultLabelFont  [UIFont robotoFontOfSize:18.f]
#define kDefaultInactiveColor [UIColor colorWithWhite:0.0f alpha:0.54]
#define kDefaultActiveColor [UIColor primaryColorForGroup:@"blue" alpha:1.f]
#define kDefaultErrorColor [UIColor primaryColorForGroup:@"red" alpha:1.f]
#define kDefaultLineHeight  22.f
//[UIFont preferredFontForStyle:MDTextStyleCaption]
#define kDefaultLabelTextColor [UIColor colorWithWhite:0.0f alpha:0.54]

@interface PaperTextField ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) UIColor *labelTextColor;
@property (strong, nonatomic) UIView *bottomBorder;
@property (strong, nonatomic) UIView *activeBorder;
@property (strong, nonatomic) UIView *disabledBorder;

@property (assign, nonatomic) BOOL floating;

@end

@implementation PaperTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.font = kDefaultTextFont;
        
        // placeholder label
        _labelFont = kDefaultLabelFont;
        _labelTextColor = kDefaultLabelTextColor;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _label.font = _labelFont;
        _label.textColor = _labelTextColor;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 1;
        _label.layer.masksToBounds = NO;
        [self addSubview:_label];
        
        // bottom border
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_label.frame) - 1, CGRectGetWidth(self.bounds), 1)];
        _bottomBorder.backgroundColor = kDefaultInactiveColor;
        [self addSubview:_bottomBorder];

        // disabled border
        _disabledBorder = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_label.frame) - 1, CGRectGetWidth(self.bounds), 1)];
//        _disabledBorder.backgroundColor = kDefaultInactiveColor;
        _disabledBorder.hidden = YES;

        CAShapeLayer *_border = [CAShapeLayer layer];
        _border.strokeColor = [kDefaultInactiveColor CGColor];
        _border.fillColor = nil;
        _border.lineDashPattern = @[@4, @2];
        _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        _border.frame = self.bounds;
        [_disabledBorder.layer addSublayer:_border];
        [self addSubview:_disabledBorder];

        // active border
        _activeBorder = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_label.frame) - 2, CGRectGetWidth(self.bounds), 2)];
        _activeBorder.backgroundColor = kDefaultActiveColor;
        _activeBorder.layer.opacity = 0.0f;
        [self addSubview:_activeBorder];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setPlaceholder:(NSString *)placeholder
{
    [_label setText:placeholder];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    _disabledBorder.hidden = enabled;
    _bottomBorder.hidden = !enabled;
}

- (BOOL)becomeFirstResponder
{
    BOOL flag = [super becomeFirstResponder];
    if (flag) {
        if (self.floatingLabel) {
            if (self.text.length == 0 || !self.floating) {
                // float the label to above
                [self floatLabelToTop];
                self.floating = YES;
            }
        } else {
            // simply hide the label
            _label.layer.opacity = 0.f;
        }
        
        // show active border
        [self showActiveBorder];
    }
    return flag;
}

- (BOOL)resignFirstResponder
{
    BOOL flag = [super resignFirstResponder];
    if (flag) {
        if (self.floatingLabel) {
            if (self.floating && self.text.length == 0) {
                // animate the label into the control
                [self animateLabelBack];
                self.floating = NO;
            }
        } else {
            _label.layer.opacity = 1.f;
        }
        
        // show inactive border
        [self showInactiveBorder];
        
        // validate text
        if (self.validationBlock) {
            NSString *message = nil;
            if (!self.validationBlock(self.text, &message)) {
                // TODO: show error color
            }
        }
    }
    return flag;
}

#pragma mark - Private Method
- (void)showActiveBorder
{
    _activeBorder.layer.transform = CATransform3DMakeScale(0.01f, 1.0f, 1);
//    .frame = CGRectMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - 2, 0, 2);
    _activeBorder.layer.opacity = 1.0f;
    
    [CATransaction begin];
        _activeBorder.layer.transform = CATransform3DMakeScale(0.01f, 1.0f, 1);

    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromTransform = CATransform3DMakeScale(0.01f, 1.0f, 1);
    CATransform3D toTransform = CATransform3DMakeScale(1.0f, 1.0f, 1);
    anim2.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    anim2.toValue = [NSValue valueWithCATransform3D:toTransform];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = NO;
    
    [_activeBorder.layer addAnimation:anim2 forKey:@"_activeBorder"];
    
    [CATransaction commit];
}

- (void)showInactiveBorder
{
    [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            _activeBorder.layer.opacity = 0.0f;
        }];
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromTransform = CATransform3DMakeScale(1.0f, 1.0f, 1);
    CATransform3D toTransform = CATransform3DMakeScale(0.01f, 1.0f, 1);
    anim2.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    anim2.toValue = [NSValue valueWithCATransform3D:toTransform];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = NO;
    
    [_activeBorder.layer addAnimation:anim2 forKey:@"_activeBorder"];
    
    [CATransaction commit];
}


- (void)floatLabelToTop
{
    [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            _label.textColor = kDefaultActiveColor;
        }];

    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromTransform = CATransform3DMakeScale(1.0f, 1.0f, 1);
    CATransform3D toTransform = CATransform3DMakeScale(0.5, 0.5, 1);
    toTransform = CATransform3DTranslate(toTransform, -CGRectGetWidth(_label.frame)/2.f, -CGRectGetHeight(_label.frame), 0);
    
    anim2.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    anim2.toValue = [NSValue valueWithCATransform3D:toTransform];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[anim2];
    animGroup.duration = 0.3f;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.removedOnCompletion = NO;
    
    [_label.layer addAnimation:animGroup forKey:@"_floatingLabel"];
    self.clipsToBounds = NO;
    [CATransaction commit];
}

- (void)animateLabelBack
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        _label.textColor = kDefaultInactiveColor;
    }];

    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromTransform = CATransform3DMakeScale(0.5f, 0.5f, 1);
    fromTransform = CATransform3DTranslate(fromTransform, -CGRectGetWidth(_label.frame)/2.f, -CGRectGetHeight(_label.frame), 0);
    CATransform3D toTransform = CATransform3DMakeScale(1.0f, 1.0f, 1);
//    transform = CATransform3DTranslate(transform, CGRectGetWidth(_label.frame)/2.f, CGRectGetHeight(_label.frame)/2.f, 0);
    anim2.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    anim2.toValue = [NSValue valueWithCATransform3D:toTransform];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[anim2];
    animGroup.duration = 0.3f;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.removedOnCompletion = NO;
    
    [_label.layer addAnimation:animGroup forKey:@"_animateLabelBack"];
    
    [CATransaction commit];
}
@end
