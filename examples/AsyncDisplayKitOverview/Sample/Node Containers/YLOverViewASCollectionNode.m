//
//  YLOverViewASCollectionNode.m
//  Sample
//
//  Created by guimi on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "YLOverViewASCollectionNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface YLOverViewASCollectionNode()<ASCollectionDelegate,ASCollectionDataSource>

/** collection */
@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end

@implementation YLOverViewASCollectionNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        [self addSubnode:_collectionNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _collectionNode.style.width = ASDimensionMakeWithFraction(1.0);
    _collectionNode.style.height = ASDimensionMakeWithFraction(1.0);
    return [ASWrapperLayoutSpec wrapperWithLayoutElement:_collectionNode];
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

// 线程安全的
- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ^{
        ASTextCellNode *cellNode = [ASTextCellNode new];
        cellNode.backgroundColor = UIColor.lightGrayColor;
        cellNode.text = [NSString stringWithFormat:@"row : %ld",indexPath.row];
        return cellNode;
    };
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake(CGSizeMake(100, 100));
}

@end
