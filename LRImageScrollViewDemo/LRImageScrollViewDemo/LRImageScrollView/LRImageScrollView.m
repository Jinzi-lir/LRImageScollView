//
//  LRImageScrollView.m
//
//  Created by lirong on 16/6/23.
//

#import "LRImageScrollView.h"
#define SELF_WIDTH self.frame.size.width
#define SELF_HEIGHT self.frame.size.height


@interface LRImageScrollView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSTimer *timer;
@end
@implementation LRImageScrollView
#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame andImageNameArray:(NSArray *)imageNameArray
{
    if (self = [super initWithFrame:frame]) {
        self.imageNameArray = imageNameArray;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT)];
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SELF_WIDTH * _imageNameArray.count, 0);
    [self addSubview:self.scrollView];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(20, self.frame.size.height - 20, 10*_imageNameArray.count, 20);
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    _pageControl.numberOfPages = _imageNameArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self setPageControlMode:PAGECONTROLMODEL_RIGHT];
    [self addSubview:_pageControl];
    for (int i = 0; i < _imageNameArray.count; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i*SELF_WIDTH, 0, SELF_WIDTH, SELF_HEIGHT)];
        [self.scrollView addSubview:imageview];
        imageview.userInteractionEnabled = YES;
        //创建手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
        [imageview addGestureRecognizer:tap];
    }
    [self updateContent];

}

- (void)tapImage
{
    if (self.delegate != nil) {
        [self.delegate clickImageAtIndex:(int)_pageControl.currentPage];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 找出最中间的那个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
    
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }

    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}

#pragma mark - 内容更新
- (void)updateContent
{
    // 设置图片
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        if (i == 0) {
            index--;
        } else if (i == 2) {
            index++;
        }
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages) {
            index = 0;
        }
        imageView.tag = index;
        imageView.image = [UIImage imageNamed:self.imageNameArray[index]];
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - 定时器处理
- (void)addTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
//定时器调用方法
- (void)next
{
    [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
}

- (void)setPageControlMode:(PageControlMode)pageControlMode
{
    CGRect rect = _pageControl.frame;
    if (pageControlMode == PAGECONTROLMODEL_LEFT) {
        rect.origin.x =  20;
    } else if (pageControlMode == PAGECONTROLMODEL_RIGHT) {
        rect.origin.x =  self.frame.size.width - rect.size.width - 20;
    } else if (pageControlMode == PAGECONTROLMODEL_CENTER) {
        _pageControl.center = CGPointMake(self.frame.size.width/2, rect.origin.y);
        return;
    }
    _pageControl.frame = rect;
}

@end
