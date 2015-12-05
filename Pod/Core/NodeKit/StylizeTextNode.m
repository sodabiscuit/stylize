//
//  StylizeLabelNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeTextNode.h"
#import "StylizeCSSRule.h"

@implementation StylizeTextNode

- (instancetype)init {
    return [super initWithViewClass:[UILabel class]];
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

@end
