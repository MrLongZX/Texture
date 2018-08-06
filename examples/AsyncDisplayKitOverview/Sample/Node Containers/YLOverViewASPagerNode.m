//
//  YLOverViewASPagerNode.m
//  Sample
//
//  Created by guimi on 2018/8/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "YLOverViewASPagerNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

static UIColor *OverViewASPagerNodeRandomColor() {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@interface YLOverViewASPageCell : ASCellNode

@end

@implementation YLOverViewASPageCell

- (ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize
{
    return [ASLayout layoutWithLayoutElement:self size:constrainedSize.max];
}

@end


@interface YLOverViewASPagerNode()<ASPagerDelegate, ASPagerDataSource>

@property (nonatomic, strong) ASPagerNode *pager;

@end

@implementation YLOverViewASPagerNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pager = [ASPagerNode new];
        _pager.delegate = self;
        _pager.dataSource = self;
        [self addSubnode:_pager];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _pager.style.width = ASDimensionMakeWithFraction(1.0);
    _pager.style.height = ASDimensionMakeWithFraction(1.0);
    return [ASWrapperLayoutSpec wrapperWithLayoutElement:_pager];
}

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode
{
    return 4;
}

- (ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index
{
    return ^{
        YLOverViewASPageCell *cell = [YLOverViewASPageCell new];
        cell.backgroundColor = OverViewASPagerNodeRandomColor();
        return cell;
    };
}


@end
