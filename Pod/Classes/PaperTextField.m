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
#import <PureLayout/PureLayout.h>

#define kDefaultFloatingLabelFont [UIFont robotoMediumFontOfSize:12.f]
#define kDefaultTextFont [UIFont robotoMediumFontOfSize:18.f]
#define kDefaultLabelFont  [UIFont robotoFontOfSize:18.f]
#define kDefaultInactiveColor [UIColor colorWithWhite:0.0f alpha:0.54]
#define kDefaultActiveColor [UIColor primaryColorForGroup:@"blue" alpha:1.f]
#define kDefaultErrorColor [UIColor primaryColorForGroup:@"red" alpha:1.f]
#define kDefaultLineHeight  22.f
#define kDefaultLabelTextColor [UIColor colorWithWhite:0.0f alpha:0.54]

@interface PaperTextField ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) UIColor *labelTextColor;
@property (strong, nonatomic) UIView *activeBorder;

@property (assign, nonatomic) BOOL floating;
@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) BOOL hasError;
@property (strong, nonatomic) NSString *errorMessage;

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
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = _labelFont;
        _label.textColor = _labelTextColor;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 1;
        _label.layer.masksToBounds = NO;
        [self addSubview:_label];

        // active border
        _activeBorder = [[UIView alloc] initWithFrame:CGRectZero];
        _activeBorder.backgroundColor = kDefaultActiveColor;
        _activeBorder.layer.opacity = 0.0f;
        [self addSubview:_activeBorder];
        
        // auto layout constrains
        [_label autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [_label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_label autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [_label autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];

        [_activeBorder autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [_activeBorder autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_activeBorder autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_activeBorder autoSetDimension:ALDimensionHeight toSize:2.f];
        
        // monitor text changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [_label setText:placeholder];
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
            // change placeholder color
            _label.textColor = kDefaultActiveColor;

            // simply hide the label
            _label.layer.opacity = 0.f;
        }

        // show active border
        [self showActiveBorder];
    }
    _active = flag;
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
            if (self.text.length == 0) {
                _label.layer.opacity = 1.f;
            }
        }
        
        // change placeholder color
        _label.textColor = kDefaultInactiveColor;
        
        // show inactive border
        [self showInactiveBorder];
        
        // validate text
        [self validate];
    }
    _active = flag;
    return flag;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // draw border layer
    UIColor *borderColor = _hasError ? kDefaultErrorColor : kDefaultInactiveColor;
    CGRect textRect = [self textRectForBounds:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint borderLines[2] = {
        CGPointMake(0, CGRectGetHeight(textRect) - 1),
        CGPointMake(CGRectGetWidth(textRect), CGRectGetHeight(textRect) - 1)
    };
    if (self.enabled) {
        
        CGContextBeginPath(context);
        CGContextAddLines(context, borderLines, 2);
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
        CGContextStrokePath(context);
        
    } else {

        CGContextBeginPath(context);
        CGContextAddLines(context, borderLines, 2);
        CGContextSetLineWidth(context, 1.0f);
        CGFloat dashPattern[2] = {2, 4};
        CGContextSetLineDash(context, 0, dashPattern, 2);
        CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
        CGContextStrokePath(context);

    }
}

#pragma mark - Private Method

- (void)textDidChange:(NSNotification *)notif
{
    [self validate];
}

- (void)validate
{
    if (self.validationBlock) {
        NSString *message = nil;
        BOOL isValid = self.validationBlock(self.text, &message);
        if (!isValid) {
            _hasError = YES;
            _errorMessage = message;
            self.labelTextColor = kDefaultErrorColor;
            self.activeBorder.backgroundColor = kDefaultErrorColor;
            [self setNeedsDisplay];
        } else {
            _hasError = NO;
            _errorMessage = nil;
            self.labelTextColor = kDefaultActiveColor;
            self.activeBorder.backgroundColor = kDefaultActiveColor;
            [self setNeedsDisplay];
        }
    }
}

- (void)showActiveBorder
{
    _activeBorder.layer.transform = CATransform3DMakeScale(0.01f, 1.0f, 1);
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

PaperTextFieldValidationBlock PaperTextFieldEmailValidator = ^BOOL(NSString *text, NSString **message) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isValid = [emailTest evaluateWithObject:text];
    if (!isValid && message) {
        *message = NSLocalizedString(@"Invalid Email Address", nil);
    }
    return isValid;
};

PaperTextFieldValidationBlock PaperTextFieldNumberValidator = ^BOOL(NSString *text, NSString **message) {
    NSString *numRegex = @"[0-9.+-]+";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    
    BOOL isValid = [numTest evaluateWithObject:text];
    if (!isValid && message) {
        *message = NSLocalizedString(@"Invalid Number", nil);
    }
    return isValid;
};

