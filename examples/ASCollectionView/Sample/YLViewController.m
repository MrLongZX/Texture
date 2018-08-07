//
//  YLViewController.m
//  Sample
//
//  Created by guimi on 2018/8/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "YLViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ItemNode.h"
#import "SupplementaryNode.h"

@interface YLViewController ()<ASCollectionDelegate, ASCollectionDataSource, ASCollectionGalleryLayoutPropertiesProviding>

/** collection */
@property (nonatomic, strong) ASCollectionNode *collectionNode;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *data;
/** 手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation YLViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
  [self.view addGestureRecognizer:_longPressGesture];
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
  layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
  layout.itemSize = CGSizeMake(180,90);
  
  self.collectionNode = [[ASCollectionNode alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
  _collectionNode.delegate = self;
  _collectionNode.dataSource = self;
  _collectionNode.backgroundColor = UIColor.whiteColor;
  [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
  [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
  [self.view addSubnode:_collectionNode];
  
  self.navigationItem.leftItemsSupplementBackButton = YES;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped)];
  
  [self loadData];
}

- (void)loadData
{
  _data = [[NSMutableArray alloc] init];
  for (NSUInteger i = 0; i < 10; i++) {
    NSMutableArray *itmes = [[NSMutableArray alloc] init];
    for (NSUInteger j = 0; j < 10; j++) {
      itmes[j] = [NSString stringWithFormat:@"[%zd %zd]", i, j];
    }
    _data[i] = itmes;
  }
}

- (void)reloadTapped
{
  [_collectionNode reloadData];
}

- (void)handleLongPress
{
  UICollectionView *collectionView = _collectionNode.view;
  CGPoint location = [_longPressGesture locationInView:collectionView];
  switch (_longPressGesture.state) {
    case UIGestureRecognizerStateBegan: {
      NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:location];
      if (indexPath) {
        [collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
      }
    }
      break;
    case UIGestureRecognizerStateChanged:
      [collectionView updateInteractiveMovementTargetPosition:location];
      break;
      
    case UIGestureRecognizerStateEnded:
      [collectionView endInteractiveMovement];
      break;
      
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStateCancelled:
      [collectionView cancelInteractiveMovement];
      break;
    case UIGestureRecognizerStatePossible:
      
      break;
  }
}

- (CGSize)galleryLayoutDelegate:(ASCollectionGalleryLayoutDelegate *)delegate sizeForElements:(ASElementMap *)elements
{
  return CGSizeMake(180, 90);
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
  return _data.count;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
  return [_data[section] count];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *string = _data[indexPath.section][indexPath.row];
  return ^{
    return [[ItemNode alloc] initWithString:string];
  };
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  NSString *title = [kind isEqualToString:UICollectionElementKindSectionHeader] ? @"Header" : @"Footer";
  SupplementaryNode *node = [[SupplementaryNode alloc] initWithText:title];
  node.backgroundColor = [kind isEqualToString:UICollectionElementKindSectionHeader] ? UIColor.blueColor : UIColor.redColor;
  return node;
}

- (BOOL)collectionNode:(ASCollectionNode *)collectionNode canMoveItemWithNode:(ASCellNode *)node
{
  return YES;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  NSMutableArray *sectionArray = _data[sourceIndexPath.section];
  NSString *string = sectionArray[sourceIndexPath.item];
  [sectionArray removeObjectAtIndex:sourceIndexPath.item];
  [_data[destinationIndexPath.section] insertObject:string atIndex:destinationIndexPath.item];
  
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
  [context completeBatchFetching:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end
