//
//  YLDetailRootNode.h
//  Sample
//
//  Created by guimi on 2018/7/25.
//  Copyright © 2018年 AsyncDisplayKit. All rights reserved.
//

#import <AsyncDisplayKit/ASDisplayNode.h>
@class ASCollectionNode;

@interface YLDetailRootNode : ASDisplayNode

/** collection node */
@property (nonatomic, strong) ASCollectionNode *collectionNode;

- (instancetype)initWithImageCategory:(NSString *)imageCategory;

@end
