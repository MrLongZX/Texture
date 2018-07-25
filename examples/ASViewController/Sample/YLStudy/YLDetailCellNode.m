//
//  YLDetailCellNode.m
//  Sample
//
//  Created by guimi on 2018/7/25.
//  Copyright © 2018年 AsyncDisplayKit. All rights reserved.
//

#import "YLDetailCellNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface YLDetailCellNode()

/** 图片 */
@property (nonatomic, strong) ASNetworkImageNode *imageNode;

@end

@implementation YLDetailCellNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        
        _imageNode = [ASNetworkImageNode new];
        _imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASWrapperLayoutSpec wrapperWithLayoutElement:_imageNode];
    //[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 5, 0, 5) child:_imageNode];
    //[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0 child:_imageNode];
}

- (void)layoutDidFinish
{
    [super layoutDidFinish];
    
    _imageNode.URL = [self imageUrl];
}

- (NSURL *)imageUrl
{
    CGSize imageSize = self.calculatedSize;
    NSString *imageURLString = [NSString stringWithFormat:@"http://lorempixel.com/%ld/%ld/%@/%ld", (NSInteger)imageSize.width, (NSInteger)imageSize.height, self.imageCategory, self.row];
    return [NSURL URLWithString:imageURLString];
}

@end
