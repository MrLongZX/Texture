//
//  LayoutExampleNodes.m
//  Texture
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the /ASDK-Licenses directory of this source tree. An additional
//  grant of patent rights can be found in the PATENTS file in the same directory.
//
//  Modifications to this file made after 4/13/2017 are: Copyright (c) 2017-present,
//  Pinterest, Inc.  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

#import "LayoutExampleNodes.h"

#import <AsyncDisplayKit/UIImage+ASConvenience.h>

#import "Utilities.h"

@interface HeaderWithRightAndLeftItems ()
@property (nonatomic, strong) ASTextNode *usernameNode;
@property (nonatomic, strong) ASTextNode *postLocationNode;
@property (nonatomic, strong) ASTextNode *postTimeNode;
@end

@interface PhotoWithInsetTextOverlay ()
@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@end

@interface PhotoWithOutsetIconOverlay ()
@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASNetworkImageNode *iconNode;
@end

@interface FlexibleSeparatorSurroundingContent ()
@property (nonatomic, strong) ASImageNode *topSeparator;
@property (nonatomic, strong) ASImageNode *bottomSeparator;
@property (nonatomic, strong) ASTextNode *textNode;
@end

@implementation HeaderWithRightAndLeftItems

+ (NSString *)title
{
    return @"Header with left and right justified text";
}

+ (NSString *)descriptionTitle
{
    return @"try rotating me!";
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // 用户名
        _usernameNode = [[ASTextNode alloc] init];
        _usernameNode.attributedText = [NSAttributedString attributedStringWithString:@"hannahmbananahannahmbananahannahmbananahannahmbanana"
                                                                             fontSize:20
                                                                                color:[UIColor darkBlueColor]];
        _usernameNode.maximumNumberOfLines = 1;
        _usernameNode.truncationMode = NSLineBreakByTruncatingTail;
        
        // 位置
        _postLocationNode = [[ASTextNode alloc] init];
        _postLocationNode.maximumNumberOfLines = 1;
        _postLocationNode.attributedText = [NSAttributedString attributedStringWithString:@"Sunset Beach, San Fransisco, CA"
                                                                                 fontSize:20
                                                                                    color:[UIColor lightBlueColor]];
        _postLocationNode.maximumNumberOfLines = 1;
        _postLocationNode.truncationMode = NSLineBreakByTruncatingTail;
        
        // 时间
        _postTimeNode = [[ASTextNode alloc] init];
        _postTimeNode.attributedText = [NSAttributedString attributedStringWithString:@"30m"
                                                                             fontSize:20
                                                                                color:[UIColor lightGrayColor]];
    }
    
    return self;
}

#pragma mark - 布局
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    ASStackLayoutSpec *nameLocationStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    nameLocationStack.style.flexShrink = 1.0;
    nameLocationStack.style.flexGrow = 1.0;
    
    if (_postLocationNode.attributedText) {
        nameLocationStack.children = @[_usernameNode, _postLocationNode];
    } else {
        nameLocationStack.children = @[_usernameNode];
    }
    
    ASStackLayoutSpec *headerStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                 spacing:40
                                                                          justifyContent:ASStackLayoutJustifyContentStart
                                                                              alignItems:ASStackLayoutAlignItemsCenter
                                                                                children:@[nameLocationStack, _postTimeNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 10, 5, 10) child:headerStackSpec];
}

@end


@implementation PhotoWithInsetTextOverlay

+ (NSString *)title
{
    return @"Photo with inset text overlay";
}

+ (NSString *)descriptionTitle
{
    return @"try rotating me!";
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _photoNode = [[ASNetworkImageNode alloc] init];
        _photoNode.URL = [NSURL URLWithString:@"http://texturegroup.org/static/images/layout-examples-photo-with-inset-text-overlay-photo.png"];
        _photoNode.willDisplayNodeContentWithRenderingContext = ^(CGContextRef context, id drawParameters) {
            CGRect bounds = CGContextGetClipBoundingBox(context);
            [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:10] addClip];
        };
        
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.maximumNumberOfLines = 2;
        _titleNode.truncationMode = NSLineBreakByTruncatingTail;
        _titleNode.truncationAttributedText = [NSAttributedString attributedStringWithString:@"..." fontSize:16 color:[UIColor whiteColor]];
        _titleNode.attributedText = [NSAttributedString attributedStringWithString:@"family fall hikes" fontSize:16 color:[UIColor whiteColor]];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    CGFloat photoDimension = constrainedSize.max.width / 4.0;
    _photoNode.style.preferredSize = CGSizeMake(photoDimension, photoDimension);
    
    // INFINITY is used to make the inset unbounded
    UIEdgeInsets insets = UIEdgeInsetsMake(INFINITY, 12, 12, 12);
    ASInsetLayoutSpec *textInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:_titleNode];
    
    /// 覆盖布局 不会更改视图层级关系
    return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_photoNode overlay:textInsetSpec];;
}

@end


@implementation PhotoWithOutsetIconOverlay

+ (NSString *)title
{
    return @"Photo with outset icon overlay";
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _photoNode = [[ASNetworkImageNode alloc] init];
        _photoNode.URL = [NSURL URLWithString:@"http://texturegroup.org/static/images/layout-examples-photo-with-outset-icon-overlay-photo.png"];
        
        _iconNode = [[ASNetworkImageNode alloc] init];
        _iconNode.URL = [NSURL URLWithString:@"http://texturegroup.org/static/images/layout-examples-photo-with-outset-icon-overlay-icon.png"];
        
        [_iconNode setImageModificationBlock:^UIImage *(UIImage *image) {   // FIXME: in framework autocomplete for setImageModificationBlock line seems broken
            CGSize profileImageSize = CGSizeMake(60, 60);
            return [image makeCircularImageWithSize:profileImageSize withBorderWidth:10];
        }];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    /// 设置参考大小 布局位置
    _iconNode.style.preferredSize = CGSizeMake(40, 40);
    _iconNode.style.layoutPosition = CGPointMake(150, 0);
    
    _photoNode.style.preferredSize = CGSizeMake(150, 150);
    _photoNode.style.layoutPosition = CGPointMake(40 / 2.0, 40 / 2.0);
    
    /// 绝对布局
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[_photoNode, _iconNode]];
    
    // ASAbsoluteLayoutSpec's .sizing property recreates the behavior of ASDK Layout API 1.0's "ASStaticLayoutSpec"
    absoluteSpec.sizing = ASAbsoluteLayoutSpecSizingSizeToFit;
    
    return absoluteSpec;
}



@end


@implementation FlexibleSeparatorSurroundingContent

+ (NSString *)title
{
    return @"Top and bottom cell separator lines";
}

+ (NSString *)descriptionTitle
{
    return @"try rotating me!";
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        /// 上分割线
        _topSeparator = [[ASImageNode alloc] init];
        _topSeparator.image = [UIImage as_resizableRoundedImageWithCornerRadius:1.0 cornerColor:[UIColor blackColor] fillColor:[UIColor blackColor]];
      
        /// text节点
        _textNode = [[ASTextNode alloc] init];
        _textNode.attributedText = [NSAttributedString attributedStringWithString:@"this is a long text node"
                                                                         fontSize:16
                                                                            color:[UIColor blackColor]];
        /// 下分割线
        _bottomSeparator = [[ASImageNode alloc] init];
        _bottomSeparator.image = [UIImage as_resizableRoundedImageWithCornerRadius:1.0 cornerColor:[UIColor blackColor] fillColor:[UIColor blackColor]];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    /// 设置放大比例
    _topSeparator.style.flexGrow = 1.0;
    _bottomSeparator.style.flexGrow = 1.0;
    /// 设置交叉轴 text节点自身对齐方式
    _textNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
    
    /// 盒子布局 三个子节点
    ASStackLayoutSpec *verticalStackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStackSpec.spacing = 20;
    verticalStackSpec.justifyContent = ASStackLayoutJustifyContentCenter;
    verticalStackSpec.children = @[_topSeparator, _textNode, _bottomSeparator];
    
    /// 边距布局 设置子节点距离边界的距离 
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(60, 0, 60, 0) child:verticalStackSpec];
}

@end

@interface CornerLayoutExample ()
@property (nonatomic, strong) ASImageNode *dotNode;
@property (nonatomic, strong) ASImageNode *photoNode1;
@property (nonatomic, strong) ASTextNode *badgeTextNode;
@property (nonatomic, strong) ASImageNode *badgeImageNode;
@property (nonatomic, strong) ASImageNode *photoNode2;
@end

@implementation CornerLayoutExample

static CGFloat const kSampleAvatarSize = 100;
static CGFloat const kSampleIconSize = 26;
static CGFloat const kSampleBadgeCornerRadius = 12;

+ (NSString *)title
{
    return @"Declarative way for Corner image Layout";
}

+ (NSString *)descriptionTitle
{
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 头像
        UIImage *avatarImage = [self avatarImageWithSize:CGSizeMake(kSampleAvatarSize, kSampleAvatarSize)];
        /// 角标
        UIImage *cornerImage = [self cornerImageWithSize:CGSizeMake(kSampleIconSize, kSampleIconSize)];
        
        NSAttributedString *numberText = [NSAttributedString attributedStringWithString:@" 999+ " fontSize:20 color:UIColor.whiteColor];
        
        _dotNode = [ASImageNode new];
        _dotNode.image = cornerImage;
        
        _photoNode1 = [ASImageNode new];
        _photoNode1.image = avatarImage;
        
        _badgeTextNode = [ASTextNode new];
        _badgeTextNode.attributedText = numberText;
        
        _badgeImageNode = [ASImageNode new];
        _badgeImageNode.image = [UIImage as_resizableRoundedImageWithCornerRadius:kSampleBadgeCornerRadius
                                                                      cornerColor:UIColor.clearColor
                                                                        fillColor:UIColor.redColor];
        
        _photoNode2 = [ASImageNode new];
        _photoNode2.image = avatarImage;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    /// 第二个组合的角标 背景布局 一个红色image节点当背景，白色数字text节点展示角标数
    ASBackgroundLayoutSpec *badgeSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:_badgeTextNode
                                                                                   background:_badgeImageNode];
    /// 第一个带角标的组合
    ASCornerLayoutSpec *cornerSpec1 = [ASCornerLayoutSpec cornerLayoutSpecWithChild:_photoNode1 corner:_dotNode location:ASCornerLayoutLocationTopRight];
    cornerSpec1.offset = CGPointMake(-3, 3);
    
    /// 第二个带角标的组合
    ASCornerLayoutSpec *cornerSpec2 = [ASCornerLayoutSpec cornerLayoutSpecWithChild:_photoNode2 corner:badgeSpec location:ASCornerLayoutLocationTopRight];
    
    self.photoNode.style.preferredSize = CGSizeMake(kSampleAvatarSize, kSampleAvatarSize);
    self.iconNode.style.preferredSize = CGSizeMake(kSampleIconSize, kSampleIconSize);
    /// 第三个带角标的组合 边角布局
    ASCornerLayoutSpec *cornerSpec3 = [ASCornerLayoutSpec cornerLayoutSpecWithChild:self.photoNode corner:self.iconNode location:ASCornerLayoutLocationTopRight];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    stackSpec.spacing = 40;
    stackSpec.children = @[cornerSpec1, cornerSpec2, cornerSpec3];
    
    return stackSpec;
}

- (UIImage *)avatarImageWithSize:(CGSize)size
{
    return [UIImage imageWithSize:size fillColor:UIColor.lightGrayColor shapeBlock:^UIBezierPath *{
        CGRect rect = (CGRect){ CGPointZero, size };
        return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:MIN(size.width, size.height) / 20];
    }];
}

- (UIImage *)cornerImageWithSize:(CGSize)size
{
    return [UIImage imageWithSize:size fillColor:UIColor.redColor shapeBlock:^UIBezierPath *{
        return [UIBezierPath bezierPathWithOvalInRect:(CGRect){ CGPointZero, size }];
    }];
}

@end


@interface UserProfileSample ()
@property (nonatomic, strong) ASImageNode *badgeNode;
@property (nonatomic, strong) ASImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *usernameNode;
@property (nonatomic, strong) ASTextNode *subtitleNode;
@property (nonatomic, assign) CGFloat photoSizeValue;
@property (nonatomic, assign) CGFloat iconSizeValue;
@end

@implementation UserProfileSample

+ (NSString *)title
{
    return @"Common user profile layout.";
}

+ (NSString *)descriptionTitle
{
    return @"For corner image layout and text truncation.";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoSizeValue = 44;
        _iconSizeValue = 15;
        
        CGSize iconSize = CGSizeMake(_iconSizeValue, _iconSizeValue);
        CGSize photoSize = CGSizeMake(_photoSizeValue, _photoSizeValue);
        
        /// 角标
        _badgeNode = [ASImageNode new];
        _badgeNode.style.preferredSize = iconSize;
        _badgeNode.image = [UIImage imageWithSize:iconSize fillColor:UIColor.redColor shapeBlock:^UIBezierPath *{
            return [UIBezierPath bezierPathWithOvalInRect:(CGRect){ CGPointZero, iconSize }];
        }];
        
        /// 头像
        _avatarNode = [ASImageNode new];
        _avatarNode.style.preferredSize = photoSize;
        _avatarNode.image = [UIImage imageWithSize:photoSize fillColor:UIColor.lightGrayColor shapeBlock:^UIBezierPath *{
            return [UIBezierPath bezierPathWithOvalInRect:(CGRect){ CGPointZero, photoSize }];
        }];
        
        /// 用户名
        _usernameNode = [ASTextNode new];
        _usernameNode.attributedText = [NSAttributedString attributedStringWithString:@"Hello World" fontSize:17 color:UIColor.blackColor];
        _usernameNode.maximumNumberOfLines = 1;
        
        /// 子标题
        _subtitleNode = [ASTextNode new];
        _subtitleNode.attributedText = [NSAttributedString attributedStringWithString:@"This is a long long subtitle, with a long long appended string." fontSize:14 color:UIColor.lightGrayColor];
        _subtitleNode.maximumNumberOfLines = 1;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    // Apply avatar with badge
    // Normally, avatar's box size is the only photo size and it will not include the badge size.
    // Otherwise, use includeCornerForSizeCalculation property to increase the box's size if needed.
    /// 边角布局 ? 头像、角标
    ASCornerLayoutSpec *avatarBox = [ASCornerLayoutSpec new];
    avatarBox.child = _avatarNode;
    avatarBox.corner = _badgeNode;
    avatarBox.cornerLocation = ASCornerLayoutLocationBottomRight;
    avatarBox.offset = CGPointMake(-6, -6);
    
    /// 盒子布局 用户名、子标题
    ASStackLayoutSpec *textBox = [ASStackLayoutSpec verticalStackLayoutSpec];
    textBox.justifyContent = ASStackLayoutJustifyContentSpaceAround;
    textBox.children = @[_usernameNode, _subtitleNode];
    
    ASStackLayoutSpec *profileBox = [ASStackLayoutSpec horizontalStackLayoutSpec];
    profileBox.spacing = 10;
    profileBox.children = @[avatarBox, textBox];
    
    /// Apply text truncation. 设置缩小比例
    NSArray *elems = @[_usernameNode, _subtitleNode, textBox, profileBox];
    for (id <ASLayoutElement> elem in elems) {
        elem.style.flexShrink = 1;
    }
    
    /// 边距布局
    ASInsetLayoutSpec *profileInsetBox = [ASInsetLayoutSpec new];
    profileInsetBox.insets = UIEdgeInsetsMake(120, 20, INFINITY, 20);
    profileInsetBox.child = profileBox;
    
    return profileInsetBox;
}

@end

@interface SYLWrapperSample()
@property (nonatomic, strong) ASNetworkImageNode *coverImageNode;
@property (nonatomic, strong) ASTextNode *textNode;
@end

@implementation SYLWrapperSample

+ (NSString *)title
{
    return @"案例1";
}

+ (NSString *)descriptionTitle
{
    return @"案例1 填充、居中、覆盖布局";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coverImageNode = [[ASNetworkImageNode alloc] init];
        _coverImageNode.URL = [NSURL URLWithString:@"http://pic1.win4000.com/wallpaper/b/569dc7fe14f5c.jpg"];
        //_coverImageNode.style.preferredSize = CGSizeMake(100, 100);
        
        _textNode = [[ASTextNode alloc] init];
        _textNode.attributedText = [NSMutableAttributedString attributedStringWithString:@"文字内容" fontSize:15 color:[UIColor whiteColor]];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    /// 填充布局 把图片铺满整个视图
    ASWrapperLayoutSpec *wrapperLayout = [ASWrapperLayoutSpec wrapperWithLayoutElement:_coverImageNode];
    
    /// 居中布局
    ASCenterLayoutSpec *centerSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.textNode];
    
    /// 覆盖布局
    ASOverlayLayoutSpec *overSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:wrapperLayout overlay:centerSpec];
    return overSpec;
}

@end

@interface SYLModelCellSample()

/** 大图 */
@property (nonatomic, strong) ASNetworkImageNode *coverImageNode;
/** 标题 */
@property (nonatomic, strong) ASTextNode *titleNode;
/** 副标题 */
@property (nonatomic, strong) ASTextNode *subTitleNode;
/** 发布时间 */
@property (nonatomic, strong) ASTextNode *dateTextNode;
/** 分享图标 */
@property (nonatomic, strong) ASNetworkImageNode *shareImageNode;
/** 分享数量 */
@property (nonatomic, strong) ASTextNode *shareNumberNode;
/** 喜欢图标 */
@property (nonatomic, strong) ASNetworkImageNode *likeImageNode;
/** 喜欢数量 */
@property (nonatomic, strong) ASTextNode *likeNumberNode;

@end

@implementation SYLModelCellSample

+ (NSString *)title
{
    return @"案例2";
}

+ (NSString *)descriptionTitle
{
    return @"案例2 典型cell布局";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coverImageNode = [[ASNetworkImageNode alloc] init];
        _coverImageNode.URL = [NSURL URLWithString:@"http://pic1.win4000.com/wallpaper/b/569dc7fe14f5c.jpg"];
        
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.attributedText = [NSAttributedString attributedStringWithString:@"这个是轻芒阅读(豌豆荚一览) APP 内 AppSo 频道 Cell 的布局，应该也是比较典型的布局之一" fontSize:16 color:UIColor.blackColor];
        
        _subTitleNode = [[ASTextNode alloc] init];
        _subTitleNode.attributedText = [NSAttributedString attributedStringWithString:@"Texture 拥有自己的一套成熟布局方案，虽然学习成本略高，但至少比原生的 AutoLayout 写起来舒服，重点是性能远好于 AutoLayout ，Texture 文档上也指出了这套布局方案的的优点" fontSize:13 color:UIColor.blackColor];
        
        _dateTextNode = [[ASTextNode alloc] init];
        _dateTextNode.attributedText = [NSAttributedString attributedStringWithString:@"昨天" fontSize:12 color:UIColor.blackColor];
        
        _shareImageNode = [[ASNetworkImageNode alloc] init];
        _shareImageNode.URL = [NSURL URLWithString:@"http://pic1.win4000.com/wallpaper/b/569dc7fe14f5c.jpg"];
        
        _shareNumberNode = [[ASTextNode alloc] init];
        _shareNumberNode.attributedText = [NSAttributedString attributedStringWithString:@"12" fontSize:12 color:UIColor.blackColor];
        
        _likeImageNode = [[ASNetworkImageNode alloc] init];
        _likeImageNode.URL = [NSURL URLWithString:@"http://pic1.win4000.com/wallpaper/b/569dc7fe14f5c.jpg"];
        
        _likeNumberNode = [[ASTextNode alloc] init];
        _likeNumberNode.attributedText = [NSAttributedString attributedStringWithString:@"20" fontSize:12 color:UIColor.blackColor];
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.shareImageNode.style.preferredSize = CGSizeMake(15, 15);
    self.likeImageNode.style.preferredSize = CGSizeMake(15, 15);
    
    ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    likeLayout.spacing = 4.0;
    likeLayout.justifyContent = ASStackLayoutJustifyContentStart;
    likeLayout.alignItems = ASStackLayoutAlignItemsCenter;
    likeLayout.children = @[self.likeImageNode, self.likeNumberNode];

    ASStackLayoutSpec *shareLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    shareLayout.spacing = 4.0;
    shareLayout.justifyContent = ASStackLayoutJustifyContentStart;
    shareLayout.alignItems = ASStackLayoutAlignItemsCenter;
    shareLayout.children = @[self.shareImageNode, self.shareNumberNode];
    
    ASStackLayoutSpec *otherLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    otherLayout.spacing = 12.0;
    otherLayout.justifyContent = ASStackLayoutJustifyContentStart;
    otherLayout.alignItems = ASStackLayoutAlignItemsCenter;
    otherLayout.children = @[likeLayout, shareLayout];
    
    ASStackLayoutSpec *bottomLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    bottomLayout.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    bottomLayout.alignItems = ASStackLayoutAlignItemsCenter;
    bottomLayout.children = @[self.dateTextNode, otherLayout];
    
    self.titleNode.style.spacingBefore = 12;
    
    self.subTitleNode.style.spacingBefore = 16;
    self.subTitleNode.style.spacingAfter = 20;
    
    ASRatioLayoutSpec *rationLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:0.5 child:self.coverImageNode];
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    contentLayout.justifyContent = ASStackLayoutJustifyContentStart;
    contentLayout.alignItems = ASStackLayoutAlignItemsStretch;
    contentLayout.children = @[rationLayout, self.titleNode, self.subTitleNode, bottomLayout];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16, 16, 16, 16) child:contentLayout];
    
    return insetLayout;
}

@end

@interface SYLAbsoluteSample()
/** node1 */
@property (nonatomic, strong) ASDisplayNode *node1;
/** node2 */
@property (nonatomic, strong) ASDisplayNode *node2;
/** node3 */
@property (nonatomic, strong) ASDisplayNode *node3;
/** node4 */
@property (nonatomic, strong) ASDisplayNode *node4;
/** node5 */
@property (nonatomic, strong) ASDisplayNode *node5;
@end

@implementation SYLAbsoluteSample

+ (NSString *)title
{
    return @"案例3";
}

+ (NSString *)descriptionTitle
{
    return @"案例3 绝对布局例子";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _node1 = [[ASDisplayNode alloc] init];
        _node1.backgroundColor = UIColor.lightBlueColor;
        
        _node2 = [[ASDisplayNode alloc] init];
        _node2.backgroundColor = UIColor.greenColor;
        
        _node3 = [[ASDisplayNode alloc] init];
        _node3.backgroundColor = UIColor.lightBlueColor;
        
        _node4 = [[ASDisplayNode alloc] init];
        _node4.backgroundColor = UIColor.lightBlueColor;
        
        _node5 = [[ASDisplayNode alloc] init];
        _node5.backgroundColor = UIColor.lightBlueColor;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.node1.style.preferredSize = CGSizeMake(constrainedSize.max.width, 136);
    
    self.node2.style.preferredSize = CGSizeMake(58, 25);
    self.node2.style.layoutPosition = CGPointMake(14, 95);
    
    self.node3.style.height = ASDimensionMake(37);
    self.node4.style.preferredSize = CGSizeMake(80, 20);
    self.node5.style.preferredSize =  CGSizeMake(80, 20);
    
    // 布局规则 主轴方向 前后间隔
    self.node4.style.spacingBefore = 14;
    self.node5.style.spacingAfter = 14;
    
    ASAbsoluteLayoutSpec *absoluteLayout = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.node2]];
    ASOverlayLayoutSpec *overLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.node1 overlay:absoluteLayout];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 14, 0, 14) child:self.node3];
    // 布局规则也有style
    insetLayout.style.spacingBefore = 13;
    insetLayout.style.spacingAfter = 25;
    
    ASStackLayoutSpec *bottomLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    bottomLayout.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    bottomLayout.alignItems = ASStackLayoutAlignItemsCenter;
    bottomLayout.children = @[self.node4, self.node5];
    bottomLayout.style.spacingAfter = 10;
    
    ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    stackLayout.justifyContent = ASStackLayoutJustifyContentStart;
    stackLayout.alignItems = ASStackLayoutAlignItemsStretch;
    stackLayout.children = @[overLayout, insetLayout, bottomLayout];
    
    return stackLayout;
}

@end

@interface SYLFlexGrowSample()
/** node1 */
@property (nonatomic, strong) ASDisplayNode *node1;
/** node2 */
@property (nonatomic, strong) ASDisplayNode *node2;
/** node3 */
@property (nonatomic, strong) ASDisplayNode *node3;
/** node4 */
@property (nonatomic, strong) ASDisplayNode *node4;
@end

@implementation SYLFlexGrowSample

+ (NSString *)title
{
    return @"案例4";
}

+ (NSString *)descriptionTitle
{
    return @"案例4 flowGrow用法";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _node1 = [[ASDisplayNode alloc] init];
        _node1.backgroundColor = UIColor.lightBlueColor;
        
        _node2 = [[ASDisplayNode alloc] init];
        _node2.backgroundColor = UIColor.lightBlueColor;
        
        _node3 = [[ASDisplayNode alloc] init];
        _node3.backgroundColor = UIColor.lightBlueColor;
        
        _node4 = [[ASDisplayNode alloc] init];
        _node4.backgroundColor = UIColor.lightBlueColor;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.node1.style.height = ASDimensionMake(20);
    
    NSMutableArray *layoutArray = @[].mutableCopy;
    
    NSArray *nodeArray = @[self.node2, self.node3, self.node4];
    for (ASDisplayNode *node in nodeArray) {
        // 注意 2/3 作为第一个参数 会蹦
        ASRatioLayoutSpec *ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:2.0/3.0 child:node];
        ratioLayout.style.flexGrow = 1;
        [layoutArray addObject:ratioLayout];
    }
    
    ASStackLayoutSpec *imageLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    imageLayout.justifyContent = ASStackLayoutJustifyContentStart;
    imageLayout.alignItems = ASStackLayoutAlignItemsStart;
    imageLayout.spacing = 14;
    imageLayout.children = layoutArray;
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    contentLayout.justifyContent = ASStackLayoutJustifyContentStart;
    contentLayout.alignItems = ASStackLayoutAlignItemsStretch;
    contentLayout.spacing = 22;
    contentLayout.children = @[self.node1, imageLayout];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(22, 16, 22, 16) child:contentLayout];
}

@end

@interface SYLFlexShrinkSample()
/** node */
@property (nonatomic, strong) ASDisplayNode *node;
/** 标题 */
@property (nonatomic, strong) ASTextNode *titleNode;
@end

@implementation SYLFlexShrinkSample

+ (NSString *)title
{
    return @"案例5";
}

+ (NSString *)descriptionTitle
{
    return @"案例5 flowShrink用法";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _node = [[ASDisplayNode alloc] init];
        _node.backgroundColor = UIColor.lightBlueColor;
        
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.attributedText = [NSAttributedString attributedStringWithString:@"这个是轻芒阅读(豌豆荚一览) APP 内 AppSo 频道 Cell 的布局，应该也是比较典型的布局之一" fontSize:16 color:UIColor.blackColor];
        _titleNode.maximumNumberOfLines = 1;
        _titleNode.truncationMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.node.style.preferredSize = CGSizeMake(42, 18);
    self.titleNode.style.flexShrink = 1;
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    contentLayout.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    contentLayout.alignItems = ASStackLayoutAlignItemsStart;
    contentLayout.children = @[self.titleNode, self.node];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16, 16, 16, 16) child:contentLayout];
    return insetLayout;
}

@end


@implementation LayoutExampleNode

+ (NSString *)title
{
    NSAssert(NO, @"All layout example nodes must provide a title!");
    return nil;
}

+ (NSString *)descriptionTitle
{
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

