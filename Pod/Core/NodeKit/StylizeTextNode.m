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
    
    if (self.CSSRule.display == StylizeDisplayInline) {
        label.numberOfLines = 0;
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
    if (self.CSSRule.width == 0 &&
        self.CSSRule.height == 0) {
        StylizeNodeMeasureBlock block = ^CGSize(CGFloat width) {
            if ([self hasAttributedText]) {
                if (![self.attributedText isEqualToAttributedString:self.cachedAttributedText]) {
                    _cachedSize = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
                    _cachedAttributedText = self.attributedText;
                }
            } else {
                if (![self.text isEqualToString:self.cachedText]) {
                    _cachedSize = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
                    _cachedText = self.text;
                }
            }
            return _cachedSize;
        };
        return block;
    }
    
    return nil;
}

- (BOOL)hasAttributedText {
    return _attributedText.length > 0;
}

@end
