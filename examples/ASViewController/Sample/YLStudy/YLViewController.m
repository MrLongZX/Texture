//
//  YLViewController.m
//  Sample
//
//  Created by guimi on 2018/7/25.
//  Copyright © 2018年 AsyncDisplayKit. All rights reserved.
//

#import "YLViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "YLDetailRootNode.h"
#import "YLDetailViewController.h"

@interface YLViewController()<ASTableDelegate, ASTableDataSource>

/** table node */
@property (nonatomic, strong) ASTableNode *tableNode;
/** 数据 */
@property (nonatomic, copy) NSArray *imageCategories;

@end

@implementation YLViewController

- (instancetype)init
{
    _tableNode = [ASTableNode new];
    self = [super initWithNode:_tableNode];
    if (self) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        
        _imageCategories = @[@"abstract", @"animals", @"business", @"cats", @"city", @"food", @"nightlife", @"fashion", @"people", @"nature", @"sports", @"technics", @"transport"];
    }
    return self;
}

- (void)dealloc
{
    _tableNode.delegate = nil;
    _tableNode.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Table Node 练习";
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return _imageCategories.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = _imageCategories[indexPath.row];
    return ^{
        ASTextCellNode *cell = [ASTextCellNode new];
        cell.text = [string  capitalizedString];
        return cell;
    };
}

// 有上一个方法存在，这个方法是不执行的
- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASTextCellNode *cell = [ASTextCellNode new];
    cell.text = [@"t666"  capitalizedString];
    return cell;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = _imageCategories[indexPath.row];
    YLDetailRootNode *rootNode = [[YLDetailRootNode alloc] initWithImageCategory:string];
    YLDetailViewController *detailVC = [[YLDetailViewController alloc] initWithNode:rootNode];
    detailVC.title = [string capitalizedString];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
