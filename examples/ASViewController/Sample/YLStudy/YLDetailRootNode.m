//
//  YLDetailRootNode.m
//  Sample
//
//  Created by guimi on 2018/7/25.
//  Copyright © 2018年 AsyncDisplayKit. All rights reserved.
//

#import "YLDetailRootNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "YLDetailCellNode.h"

@interface YLDetailRootNode()<ASCollectionDelegate, ASCollectionDataSource>

/** imageCategory */
@property (nonatomic, copy) NSString *imageCategory;

@end

@implementation YLDetailRootNode

- (instancetype)initWithImageCategory:(NSString *)imageCategory
{
    self = [super init];
    if (self) {
        _imageCategory = imageCategory;
        self.automaticallyManagesSubnodes = YES;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 25;
        
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        _collectionNode.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)dealloc
{
    _collectionNode.delegate = nil;
    _collectionNode.dataSource = nil;
}

#pragma mark - 布局
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASWrapperLayoutSpec wrapperWithLayoutElement:_collectionNode];
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageString = self.imageCategory;
    return ^{
        YLDetailCellNode *cell = [[YLDetailCellNode alloc] init];
        cell.row = indexPath.row;
        cell.imageCategory = imageString;
        return cell;
    };
}

// 有上一个方法存在，这个方法是不执行的
- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLDetailCellNode *cell = [[YLDetailCellNode alloc] init];
    cell.row = indexPath.row;
    cell.imageCategory = @"6666";
    return cell;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(collectionNode.frame.size.width, 200);
    return ASSizeRangeMake(cellSize, cellSize);
}
@end
