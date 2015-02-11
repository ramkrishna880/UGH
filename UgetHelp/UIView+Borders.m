//
//  UIView+Borders.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 04/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "UIView+Borders.h"

@implementation UIView (Borders)

- (void)applyBorderForWidth:(CGFloat)borderWidth andRadius:(CGFloat)radius {
    [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setCornerRadius:radius];
}
@end
