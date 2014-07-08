//
//  PaperToolbar.m
//  Paper
//
//  Created by Tom Li on 07/07/2014.
//  Copyright (c) 2014 Tom Li. All rights reserved.
//
#import "PaperToolbar.h"
#import <UIKit+Material/UIFont+Material.h>

@interface PaperToolbar ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) CALayer *backgroundLayer;

@end

@implementation PaperToolbar

+ (CGFloat)defaultToolbarHeight
{
    return 48.f;
}

+ (CGFloat)maxToolbarHeight
{
    return 240.f;
}

+ (instancetype)toolbarWithStyle:(PaperToolbarStyle) style parentView:(UIView *)view
{
    CGRect frame = CGRectZero;
    switch (style) {
        case PaperToolbarStyleStandard:
            frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds), [self defaultToolbarHeight]);
            break;
        case PaperToolbarStyleStandardBottom:
            frame = CGRectMake(0, CGRectGetHeight(view.bounds) - [self defaultToolbarHeight], CGRectGetWidth(view.bounds), [self defaultToolbarHeight]);
            break;
        case PaperToolbarStyleFlexible:
            frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds), [self defaultToolbarHeight]);
            break;
            
        default:
            break;
    }
    
    PaperToolbar *toolbar = [[PaperToolbar alloc] initWithFrame:frame style:style];
    [view addSubview:toolbar];
    
    return toolbar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:PaperToolbarStyleStandard];
}

- (instancetype)initWithFrame:(CGRect)frame style:(PaperToolbarStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        _state = PaperToolbarStateNormal;
        _backgroundLayer = [[CALayer alloc] init];
        
        self.layer.anchorPoint = CGPointMake(0, 0);
        self.layer.frame = self.bounds;
        // background image (hidden by default)
        _backgroundLayer.anchorPoint = CGPointMake(0, 0);
        _backgroundLayer.frame = self.layer.bounds;
        _backgroundLayer.contentsGravity = @"bottom";
        _backgroundLayer.opacity = 0.0f;
//        _backgroundLayer.anchorPoint = CGPointMake(0, 0);
        _backgroundLayer.masksToBounds = YES;
        [self.layer addSublayer:_backgroundLayer];

        // title label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, CGRectGetWidth(frame) - 16, CGRectGetHeight(frame) - 16.f)];
        [self.titleLabel setFont:[UIFont preferredFontForStyle:MDTextStyleHeadline]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setText:@"Title"];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated
{
    CGRect newframe = self.frame;
    if (animated) {
        CGFloat delta;
        switch (self.style) {
            case PaperToolbarStyleStandard:
            case PaperToolbarStyleFlexible:
                newframe.size.height = height;
                break;
            case PaperToolbarStyleStandardBottom:
                delta = newframe.size.height - height;
                newframe.size.height = height;
                newframe.origin.y -= delta;
                break;
            default:
                break;
        }
        
        [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [self setFrame:newframe];
            }];
        
            // animate layer and background layer to the new position
            CABasicAnimation *anim0 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
            anim0.fromValue = [NSValue valueWithCGSize:self.frame.size];
            anim0.toValue = [NSValue valueWithCGSize:newframe.size];
            anim0.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            anim0.fillMode = kCAFillModeForwards;
            anim0.removedOnCompletion = NO;
            anim0.duration = 0.8f;
            [self.layer addAnimation:anim0 forKey:@"_resizeAnimation"];

            // animate opacity of the background image
            CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
            anim1.fromValue = [NSValue valueWithCGSize:self.frame.size];
            anim1.toValue = [NSValue valueWithCGSize:newframe.size];
            anim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

            CGFloat toOpacity = (newframe.size.height - [PaperToolbar defaultToolbarHeight]) / ([PaperToolbar maxToolbarHeight] - [PaperToolbar defaultToolbarHeight]);
            CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            anim2.toValue = @(toOpacity);
            anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
            animGroup.animations = @[anim1, anim2];
            animGroup.duration = 0.8f;
            animGroup.fillMode = kCAFillModeForwards;
            animGroup.removedOnCompletion = NO;
            [self.backgroundLayer addAnimation:animGroup forKey:@"_resizeAnimation2"];
            
            [CATransaction commit];
    } else {
        [self setFrame:newframe];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.style == PaperToolbarStyleFlexible) {
        CGFloat opacity = (CGRectGetHeight(frame) - [PaperToolbar defaultToolbarHeight]) /
        ([PaperToolbar maxToolbarHeight] - [PaperToolbar defaultToolbarHeight]);
        self.backgroundLayer.opacity = opacity;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(PaperToolbarState)state
{
    [self.backgroundLayer setContents:(__bridge id)[backgroundImage CGImage]];
}


- (void)setTitleFrame:(CGRect)rect forState:(PaperToolbarState)state
{
    
}

- (void)setTitleFont:(UIFont *)font forState:(PaperToolbarState)state
{
    
}

@end