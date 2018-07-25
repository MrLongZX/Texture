//
//  YLDetailCellNode.h
//  Sample
//
//  Created by guimi on 2018/7/25.
//  Copyright © 2018年 AsyncDisplayKit. All rights reserved.
//

#import <AsyncDisplayKit/ASCellNode.h>

@interface YLDetailCellNode : ASCellNode

/** 位置 */
@property (nonatomic, assign) NSInteger row;
/** 分类 */
@property (nonatomic, copy) NSString *imageCategory;

@end
