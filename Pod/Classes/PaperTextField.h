//
//  PaperTextField.h
//  Pods
//
//  Created by Tom Li on 7/7/14.
//
//

#import <UIKit/UIKit.h>

typedef BOOL (^PaperTextFieldValidationBlock)(NSString *, NSString **);

@interface PaperTextField : UITextField

@property (assign, nonatomic) BOOL floatingLabel;
    // If YES, the label will "float" above the text input once the user enters text instead of disappearing
@property (strong, nonatomic) PaperTextFieldValidationBlock validationBlock;

@end

extern PaperTextFieldValidationBlock PaperTextFieldEmailValidator;
extern PaperTextFieldValidationBlock PaperTextFieldNumberValidator;
