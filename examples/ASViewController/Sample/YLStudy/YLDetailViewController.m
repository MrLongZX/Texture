//
//  YLDetailViewController.m
//  Sample
//
//  Created by guimi on 2018/7/25.
//  Copyright © 2018年 AsyncDisplayKit. All rights reserved.
//

#import "YLDetailViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "YLDetailRootNode.h"

@interface YLDetailViewController ()

@end

@implementation YLDetailViewController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.node.collectionNode.view.collectionViewLayout invalidateLayout];
}

@end
