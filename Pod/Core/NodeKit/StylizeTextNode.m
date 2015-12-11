//
//  StylizeLabelNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeTextNode.h"
#import "StylizeCSSRule.h"

@interface StylizeTextNode()

@property (nonatomic, strong) NSString *cachedText;
@property (nonatomic, strong) NSAttributedString *cachedAttributedText;
@property (nonatomic, assign) CGSize cachedSize;
@property (nonatomic, assign) CGSize cachedAttributedSize;

@end

@implementation StylizeTextNode

- (instancetype)init {
    return [self initWithViewClass:[UILabel class]];
}

- (void)layoutNode {
    [super layoutNode];
}

- (void)renderNode {
    [super renderNode];
    
    UILabel *label = (UILabel *)self.view;
    label.textAlignment = (int)self.CSSRule.textAlign;
    label.textColor = self.CSSRule.color;
    label.font = self.CSSRule.font;
    
    if ([self hasAttributedText]) {
        [label setAttributedText:_attributedText];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    UILabel *label = (UILabel *)self.view;
    [label setAttributedText:_attributedText];
}

- (void)setText:(NSString *)text {
    _text = text;
    UILabel *label = (UILabel *)self.view;
    [label setText:text];
}

- (StylizeNodeMeasureBlock)classMeasure {
    UILabel *label = (UILabel *)self.view;
    StylizeNodeMeasureBlock block = ^CGSize(CGFloat width) {
        if ([self hasAttributedText]) {
            if (![self.attributedText isEqualToAttributedString:self.cachedAttributedText]) {
                _cachedAttributedSize = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
                _cachedAttributedText = self.attributedText;
            }
            return _cachedAttributedSize;
        } else {
            if (![self.text isEqualToString:self.cachedText]) {
                _cachedSize = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
                _cachedText = self.text;
            }
            return _cachedSize;
        }
    };
    return block;
}

- (BOOL)hasAttributedText {
    return _attributedText.length > 0;
}

- (void)parseUnrecoginzedCSSRule:(NSString *)key value:(id)value {
    [super parseUnrecoginzedCSSRule:key value:value];
    UILabel *label = (UILabel *)self.view;
    if ([key isEqualToString:@"numberOfLines"]) {
        label.numberOfLines = [value integerValue];
    }
}

@end
