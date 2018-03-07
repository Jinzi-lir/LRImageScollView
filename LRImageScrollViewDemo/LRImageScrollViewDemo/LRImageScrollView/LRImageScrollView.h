//
//  LRImageScrollView.h
//
//  Created by lirong on 16/6/23.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageControlMode)
{
    PAGECONTROLMODEL_LEFT = 0,
    PAGECONTROLMODEL_CENTER,
    PAGECONTROLMODEL_RIGHT
};

@protocol LRImageScrollViewDelegate<NSObject>

@optional
/**
 *  通过该方法实现点击图片后的操作。
 *  @param index 图片下标
 */
- (void)clickImageAtIndex:(int)index;

@end

@interface LRImageScrollView : UIView
@property (weak, nonatomic) id <LRImageScrollViewDelegate>delegate;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) NSArray * imageNameArray;
- (instancetype)initWithFrame:(CGRect)frame andImageNameArray:(NSArray *)imageNameArray;
/**
 *  开启定时器
 */
- (void)addTimer;
/**
 *  关闭定时器
 */
- (void)removeTimer;
/**
 *  设置pageControl显示位置，左、中、右三种样式,默认为右侧
 *
 *  @param pageControlMode
 */
- (void)setPageControlMode:(PageControlMode)pageControlMode;
@end
