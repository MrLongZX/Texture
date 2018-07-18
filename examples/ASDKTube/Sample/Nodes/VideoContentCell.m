//
//  VideoContentCell.m
//  Sample
//
//  Created by Erekle on 5/14/16.
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "VideoContentCell.h"

#import <AsyncDisplayKit/ASVideoPlayerNode.h>

#import "Utilities.h"

#define AVATAR_IMAGE_HEIGHT     30
#define HORIZONTAL_BUFFER       10
#define VERTICAL_BUFFER         5

@interface VideoContentCell () <ASVideoPlayerNodeDelegate>

@end

@implementation VideoContentCell
{
  VideoModel *_videoModel;
  // 标题
  ASTextNode *_titleNode;
  // 头像
  ASNetworkImageNode *_avatarNode;
  // 播放器
  ASVideoPlayerNode *_videoPlayerNode;
  // 喜欢 红色区域
  ASControlNode *_likeButtonNode;
  // 喇叭
  ASButtonNode *_muteButtonNode;
}

- (instancetype)initWithVideoObject:(VideoModel *)video
{
  self = [super init];
  if (self) {
    _videoModel = video;

    _titleNode = [[ASTextNode alloc] init];
    _titleNode.attributedText = [[NSAttributedString alloc] initWithString:_videoModel.title attributes:[self titleNodeStringOptions]];
    _titleNode.style.flexGrow = 1.0;
    [self addSubnode:_titleNode];

    _avatarNode = [[ASNetworkImageNode alloc] init];
    _avatarNode.URL = _videoModel.avatarUrl;

    [_avatarNode setImageModificationBlock:^UIImage *(UIImage *image) {
      CGSize profileImageSize = CGSizeMake(AVATAR_IMAGE_HEIGHT, AVATAR_IMAGE_HEIGHT);
      return [image makeCircularImageWithSize:profileImageSize];
    }];

    [self addSubnode:_avatarNode];

    _likeButtonNode = [[ASControlNode alloc] init];
    _likeButtonNode.backgroundColor = [UIColor redColor];
    [self addSubnode:_likeButtonNode];

    _muteButtonNode = [[ASButtonNode alloc] init];
    _muteButtonNode.style.width = ASDimensionMakeWithPoints(16.0);
    _muteButtonNode.style.height = ASDimensionMakeWithPoints(22.0);
    [_muteButtonNode addTarget:self action:@selector(didTapMuteButton) forControlEvents:ASControlNodeEventTouchUpInside];

    _videoPlayerNode = [[ASVideoPlayerNode alloc] initWithURL:_videoModel.url];
    _videoPlayerNode.delegate = self;
    _videoPlayerNode.backgroundColor = [UIColor blackColor];
    [self addSubnode:_videoPlayerNode];

    [self setMuteButtonIcon];
  }
  return self;
}

#pragma mark - 标题样式
- (NSDictionary*)titleNodeStringOptions
{
  return @{
     NSFontAttributeName : [UIFont systemFontOfSize:14.0],
     NSForegroundColorAttributeName: [UIColor blackColor]
  };
}

#pragma mark - 定义节点布局
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
  // 播放器宽高
  _videoPlayerNode.style.width = ASDimensionMakeWithPoints(fullWidth);
  _videoPlayerNode.style.height = ASDimensionMakeWithPoints(fullWidth * 9 / 16);
  
  // 头像宽高
  _avatarNode.style.width = ASDimensionMakeWithPoints(AVATAR_IMAGE_HEIGHT);
  _avatarNode.style.height = ASDimensionMakeWithPoints(AVATAR_IMAGE_HEIGHT);
  
  //  喜欢按钮宽高
  _likeButtonNode.style.width = ASDimensionMakeWithPoints(50.0);
  _likeButtonNode.style.height = ASDimensionMakeWithPoints(26.0);

  // 头像、标题layout
  ASStackLayoutSpec *headerStack  = [ASStackLayoutSpec horizontalStackLayoutSpec];
  headerStack.spacing = HORIZONTAL_BUFFER;
  headerStack.alignItems = ASStackLayoutAlignItemsCenter;
  [headerStack setChildren:@[ _avatarNode, _titleNode]];

  UIEdgeInsets headerInsets      = UIEdgeInsetsMake(HORIZONTAL_BUFFER, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *headerInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:headerInsets child:headerStack];

  // 喜欢按钮layout
  ASStackLayoutSpec *bottomControlsStack  = [ASStackLayoutSpec horizontalStackLayoutSpec];
  bottomControlsStack.spacing = HORIZONTAL_BUFFER;
  bottomControlsStack.alignItems = ASStackLayoutAlignItemsCenter;
  bottomControlsStack.children = @[_likeButtonNode];

  UIEdgeInsets bottomControlsInsets = UIEdgeInsetsMake(HORIZONTAL_BUFFER, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *bottomControlsInset  = [ASInsetLayoutSpec insetLayoutSpecWithInsets:bottomControlsInsets child:bottomControlsStack];

  // 头像、标题、喜欢按钮layout
  ASStackLayoutSpec *verticalStack = [ASStackLayoutSpec verticalStackLayoutSpec];
  verticalStack.alignItems = ASStackLayoutAlignItemsStretch;
  verticalStack.children = @[headerInset, _videoPlayerNode, bottomControlsInset];
  return verticalStack;
}

#pragma mark - 设置喇叭按钮图片
- (void)setMuteButtonIcon
{
  if (_videoPlayerNode.muted) {
    [_muteButtonNode setImage:[UIImage imageNamed:@"ico-mute"] forState:UIControlStateNormal];
  } else {
    [_muteButtonNode setImage:[UIImage imageNamed:@"ico-unmute"] forState:UIControlStateNormal];
  }
}

#pragma mark - 点击喇叭按钮
- (void)didTapMuteButton
{
  _videoPlayerNode.muted = !_videoPlayerNode.muted;
  [self setMuteButtonIcon];
}

#pragma mark - ASVideoPlayerNodeDelegate
#pragma mark - 点击播放器区域 暂停、播放
- (void)didTapVideoPlayerNode:(ASVideoPlayerNode *)videoPlayer
{
  if (_videoPlayerNode.playerState == ASVideoNodePlayerStatePlaying) {
    _videoPlayerNode.controlsDisabled = !_videoPlayerNode.controlsDisabled;
    [_videoPlayerNode pause];
  } else {
    [_videoPlayerNode play];
  }
}

#pragma mark - 自定义播放器控件
- (NSDictionary *)videoPlayerNodeCustomControls:(ASVideoPlayerNode *)videoPlayer
{
  return @{
    @"muteControl" : _muteButtonNode
  };
}

#pragma mark - 播放器可用控制控件
- (NSArray *)controlsForControlBar:(NSDictionary *)availableControls
{
  NSMutableArray *controls = [[NSMutableArray alloc] init];

  if (availableControls[ @(ASVideoPlayerNodeControlTypePlaybackButton) ]) {
    [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypePlaybackButton) ]];
  }

  if (availableControls[ @(ASVideoPlayerNodeControlTypeElapsedText) ]) {
    [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypeElapsedText) ]];
  }

  if (availableControls[ @(ASVideoPlayerNodeControlTypeScrubber) ]) {
    [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypeScrubber) ]];
  }

  if (availableControls[ @(ASVideoPlayerNodeControlTypeDurationText) ]) {
    [controls addObject:availableControls[ @(ASVideoPlayerNodeControlTypeDurationText) ]];
  }

  return controls;
}

#pragma mark - Layout
- (ASLayoutSpec*)videoPlayerNodeLayoutSpec:(ASVideoPlayerNode *)videoPlayer forControls:(NSDictionary *)controls forMaximumSize:(CGSize)maxSize
{
  ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
  spacer.style.flexGrow = 1.0;

  UIEdgeInsets insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);

  if (controls[ @(ASVideoPlayerNodeControlTypeScrubber) ]) {
    // 进度条
    ASDisplayNode *scrubber = controls[ @(ASVideoPlayerNodeControlTypeScrubber) ];
    scrubber.style.height = ASDimensionMakeWithPoints(44.0);
    scrubber.style.minWidth = ASDimensionMakeWithPoints(0.0);
    scrubber.style.maxWidth = ASDimensionMakeWithPoints(maxSize.width);
    scrubber.style.flexGrow = 1.0;
  }

  NSArray *controlBarControls = [self controlsForControlBar:controls];
  NSMutableArray *topBarControls = [[NSMutableArray alloc] init];

  //Our custom control 喇叭
  if (controls[@"muteControl"]) {
    [topBarControls addObject:controls[@"muteControl"]];
  }


  ASStackLayoutSpec *topBarSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                          spacing:10.0
                                                                   justifyContent:ASStackLayoutJustifyContentStart
                                                                       alignItems:ASStackLayoutAlignItemsCenter
                                                                         children:topBarControls];

  ASInsetLayoutSpec *topBarInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:topBarSpec];

  ASStackLayoutSpec *controlbarSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:10.0
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children: controlBarControls ];
  controlbarSpec.style.alignSelf = ASStackLayoutAlignSelfStretch;



  ASInsetLayoutSpec *controlbarInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:controlbarSpec];

  controlbarInsetSpec.style.alignSelf = ASStackLayoutAlignSelfStretch;

  ASStackLayoutSpec *mainVerticalStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:0.0
                                                                          justifyContent:ASStackLayoutJustifyContentStart
                                                                              alignItems:ASStackLayoutAlignItemsStart
                                                                                children:@[topBarInsetSpec, spacer, controlbarInsetSpec]];

  return mainVerticalStack;

}
@end
