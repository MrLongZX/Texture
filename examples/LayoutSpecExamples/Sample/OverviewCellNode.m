//
//  OverviewCellNode.m
//  Sample
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "OverviewCellNode.h"
#import "LayoutExampleNodes.h"
#import "Utilities.h"

@interface OverviewCellNode ()
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *descriptionNode;
@end

@implementation OverviewCellNode

/// 初始化
- (instancetype)initWithLayoutExampleClass:(Class)layoutExampleClass
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        
        _layoutExampleClass = layoutExampleClass;
        
        /// 标题节点
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.attributedText = [NSAttributedString attributedStringWithString:[layoutExampleClass title]
                                                                          fontSize:16
                                                                             color:[UIColor blackColor]];
        /// 描述节点
        _descriptionNode = [[ASTextNode alloc] init];
        _descriptionNode.attributedText = [NSAttributedString attributedStringWithString:[layoutExampleClass descriptionTitle]
                                                                                fontSize:12
                                                                                   color:[UIColor lightGrayColor]];
    }
    return self;
}

/// 设置子节点布局规范
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    /// 利用盒子布局 设置子节点布局
    ASStackLayoutSpec *verticalStackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStackSpec.alignItems = ASStackLayoutAlignItemsStart;
    verticalStackSpec.spacing = 5.0;
    verticalStackSpec.children = @[self.titleNode, self.descriptionNode];
    
    /// 利用边距节点 设置子节点到边界的距离 同时设置（限制）cell node 的大小
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 16, 10, 10) child:verticalStackSpec];
}

@end
