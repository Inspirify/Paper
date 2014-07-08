//
//  PaperToolbar.h
//  Paper
//
//  Created by Tom Li on 07/07/2014.
//  Copyright (c) 2014 Tom Li. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum {
    PaperToolbarPositionTop,
    PaperToolbarPositionBottom
} PaperToolbarPosition;

typedef enum {
    PaperToolbarStateNormal,
    PaperToolbarStateExpanded
} PaperToolbarState;

typedef enum {
    PaperToolbarStyleStandard,
    PaperToolbarStyleStandardBottom,
    PaperToolbarStyleFlexible
} PaperToolbarStyle;

@interface PaperToolbar : UIView

@property (readonly) PaperToolbarStyle style;
@property (readonly) UILabel *titleLabel;
@property (readonly) PaperToolbarPosition position;
@property (readonly) PaperToolbarState state;

+ (CGFloat)defaultToolbarHeight;
+ (instancetype)toolbarWithStyle:(PaperToolbarStyle) style parentView:(UIView *)view;

- (instancetype)initWithFrame:(CGRect)frame style:(PaperToolbarStyle)style;

- (void)setHeight:(CGFloat)height animated:(BOOL)animated;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(PaperToolbarState)state;
- (void)setTitleFrame:(CGRect)rect forState:(PaperToolbarState)state;
- (void)setTitleFont:(UIFont *)font forState:(PaperToolbarState)state;
@end