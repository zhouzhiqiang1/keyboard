//
//  ViewUtil.h
//  PRIS
//
//  Created by lv bingru on 9/29/11.
//  Copyright 2011 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ORLoadNib(aNibName) [[[NSBundle mainBundle] loadNibNamed:aNibName owner:nil options:nil] objectAtIndex:0]
CATransform3D CATransform3DMakePerspective(CGFloat z);

@interface BrightnessWindow : UIWindow

+ (BrightnessWindow *)initGlobalInstance;
+ (void)uninitGlobalInstance;
@property (nonatomic, assign) UIWindow *customKeyWindow;

@end

@class CATransition;

@interface ViewUtil : NSObject {
    
}

#pragma mark - 屏幕操作
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)statusBarHeight;
+ (BOOL)isRetinaScreen;
+ (UIInterfaceOrientation)curOrientation;
+ (BOOL)isPortrait;
+ (UIWindow *)keyWindow;
+ (UIWindow *)mainWindow;
// 调节当前屏幕亮度，并存储到系统值
+ (void)setScreenBrightness:(CGFloat)aBrightness;
+ (void)tempTopScreenBrightness;

#pragma mark - 图片操作
+ (UIImage *)CovertToPng:(UIImage *)im withLocalpath:(NSString *)localPath;

+ (NSURL *)scaledUrlFromOriginalUrl:(NSString *)oUrl size:(CGSize)aSize;

+ (NSString *)scaledUrlStringFromOriginalUrl:(NSString *)oUrl size:(CGSize)aSize;

+ (NSString *)scaledUserPhotoUrlStringFromOriginalUrl:(NSString *)oUrl;

+ (NSString *)scaledUrlStringFromOriginalUrl:(NSString *)oUrl size:(CGSize)aSize  withBlur:(BOOL)blur;

+ (NSString *)originalUrlStringFromUrl:(NSString *)anUrl;
// view截图，如果view是可滚动的，需先将view的contentOffset设置成（0,0）
+ (UIImage *)imageFromView:(UIView *)aView;
+ (UIImage *)imageFromView:(UIView *)theView inRect:(CGRect)aRect;

+ (UIImage *)noScaleImageFromView:(UIView *)aView;
// 缩小图片大小
+ (UIImage *)scaledImage:(UIImage *)aImage ofSize:(CGSize)aSize;
+ (UIImage *)snapImageFromView:(UIView *)aView withLogoImage:(UIImage *)aLogoImage logoTitleColor:(UIColor *)aLogoColor backgroundColor:(UIColor *)aBackgoundColor needMark:(BOOL)aNeedMark;

+ (NSString *)compatibleImageName:(NSString *)aImageName;
+ (UIImage *)rotateImage:(UIImage *)aImage;
#pragma mark - 视图操作
// aview中添加一个imageView
+ (UIImageView *)showImage:(UIImage *)aImage inView:(UIView *)aView withTag:(int)aTag;
// aView中添加一个view
+ (UIView *)addViewInView:(UIView *)aView withTag:(int)aTag;
// aview中删除aTag的view
+ (void)removeViewOfTag:(int)aTag inView:(UIView *)aView;

+ (UITapGestureRecognizer *)addSwipeRightGestureForView:(UIView *)aView target:(id)target action:(SEL)action;
+ (UITapGestureRecognizer *)addSwipeLeftGestureForView:(UIView *)aView target:(id)target action:(SEL)action;
// 给view添加单击手势
+ (UITapGestureRecognizer *)addSingleTapGestureForView:(UIView *)view target:(id)target action:(SEL)action;
// 删除view中的所有手势
+ (void)removeAllGestureOfView:(UIView *)aView;

#pragma mark - label自适应
//给定宽度的label，根据string的内容计算label的高度
+ (CGFloat)updateLabel:(UILabel *)label withText:(NSString *)string;
+ (CGFloat)updateLabel:(UILabel *)label withText:(NSString *)string contstrainedSize:(CGSize)size;

#pragma mark - 字体
+ (void)updateFontOfView:(UIView *)aView;


#pragma mark - load view from nib file
+ (id)loadViewFromeNib:(NSString *)nibName;

#pragma mark - view调整
// 增加view的宽度
+ (void)extentView:(UIView *)view byOffsetX:(CGFloat)offset;

// 增加view的高度
+ (void)extentView:(UIView *)view byOffsetY:(CGFloat)offset;

// Y方向移动view
+ (void)translateView:(UIView *)view byOffsetY:(CGFloat)offset;

// X方向移动view的高度
+ (void)translateView:(UIView *)view byOffsetX:(CGFloat)offset;

+ (void)translateView:(UIView *)aView toPoint:(CGPoint)aPoint;

+ (void)resetView:(UIView *)aView ofWidth:(CGFloat)aWidth;

#pragma mark - webView操作
+ (UIScrollView *)scrollViewOfWebView:(UIWebView *)aWebView;
+ (void)hideShadowOfWebView:(UIWebView *)aWebView;

#pragma mark - other
// NSString翻译成color
+ (UIColor *)parserFromString:(NSString *)aColorString;

#pragma mark - push,present custom animation
//+ (void)customPushViewAnimationFromViewController:(UIViewController *)aFromViewController toViewController:(UIViewController *)aToViewController;
//
//+ (void)customPopViewAnimationFromViewController:(UIViewController *)aFromViewController;

+ (void)customPresentModalViewAnimationFromViewController:(UIViewController *)aFromViewController toViewController:(UIViewController *)aToViewController;

+ (void)customDissmissModalViewAnimationFromViewController:(UIViewController *)aFromViewController;

+ (void)addPushAnimationToView:(UIView *)aView aIsRight:(BOOL)aIsRight;
+ (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2;

#pragma mark - UIScrollView
/**
 *  获取横向ScrollView当前页码
 *
 *  @param scrollView scrollview
 *
 *  @return 页码
 */
+ (NSInteger)horizontalPageNumber:(UIScrollView *)scrollView;

@end


