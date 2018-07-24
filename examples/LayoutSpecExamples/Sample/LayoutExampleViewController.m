//
//  LayoutExampleViewController.m
//  Sample
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "LayoutExampleViewController.h"
#import "LayoutExampleNodes.h"

@interface LayoutExampleViewController ()
@property (nonatomic, strong) LayoutExampleNode *customNode;
@end

@implementation LayoutExampleViewController

- (instancetype)initWithLayoutExampleClass:(Class)layoutExampleClass
{
    NSAssert([layoutExampleClass isSubclassOfClass:[LayoutExampleNode class]], @"Must pass a subclass of LayoutExampleNode.");
    
    /// 指定构造器为一个view节点
    self = [super initWithNode:[ASDisplayNode new]];
    
    if (self) {
        self.title = @"Layout Example";
        
        /// 添加子节点
        _customNode = [layoutExampleClass new];
        [self.node addSubnode:_customNode];
        
        // 背景色
        BOOL needsOnlyYCentering = [layoutExampleClass isEqual:[HeaderWithRightAndLeftItems class]] ||
        [layoutExampleClass isEqual:[FlexibleSeparatorSurroundingContent class]] || [layoutExampleClass isEqual:[SYLModelCellSample class]] || [layoutExampleClass isEqual:[SYLAbsoluteSample class]] || [layoutExampleClass isEqual:[SYLFlexGrowSample class]] || [layoutExampleClass isEqual:[SYLFlexShrinkSample class]];
        
        self.node.backgroundColor = needsOnlyYCentering ? [UIColor lightGrayColor] : [UIColor whiteColor];
        
        /// 设置子节点的整体布局
        __weak __typeof(self) weakself = self;
        self.node.layoutSpecBlock = ^ASLayoutSpec*(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            /// 利用居中布局
            return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:needsOnlyYCentering ? ASCenterLayoutSpecCenteringY : ASCenterLayoutSpecCenteringXY
                                                              sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY
                                                                      child:weakself.customNode];
        };
    }
    
    return self;
}

@end
