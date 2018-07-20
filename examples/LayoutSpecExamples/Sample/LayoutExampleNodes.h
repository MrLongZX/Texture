//
//  LayoutExampleNodes.h
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

#import <AsyncDisplayKit/AsyncDisplayKit.h>

/// 继承view节点
@interface LayoutExampleNode : ASDisplayNode
+ (NSString *)title;
+ (NSString *)descriptionTitle;
@end

@interface HeaderWithRightAndLeftItems : LayoutExampleNode
@end

@interface PhotoWithInsetTextOverlay : LayoutExampleNode
@end

@interface PhotoWithOutsetIconOverlay : LayoutExampleNode
@end

@interface FlexibleSeparatorSurroundingContent : LayoutExampleNode
@end

@interface CornerLayoutExample : PhotoWithOutsetIconOverlay
@end

@interface UserProfileSample : LayoutExampleNode
@end

@interface SYLWrapperSample : LayoutExampleNode
@end

@interface SYLModelCellSample : LayoutExampleNode
@end
