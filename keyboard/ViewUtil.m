//
//  ViewUtil.m
//  PRIS
//
//  Created by lv bingru on 9/29/11.
//  Copyright 2011 zju. All rights reserved.
//

#import "ViewUtil.h"
//#import "DeviceInfo.h"
//#import "CustomSettingDef.h"
#import <QuartzCore/QuartzCore.h>

CATransform3D CATransform3DMakePerspective(CGFloat z){
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0 / z;
    return t;
}

static BrightnessWindow *gBrightnessWindow = nil;

@implementation ViewUtil


#pragma mark - 屏幕操作
+ (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)statusBarHeight
{
    return 20.0;
}

+ (BOOL)isRetinaScreen
{
    return [UIScreen mainScreen].scale !=1.0;
}

+ (UIInterfaceOrientation)curOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

+ (UIWindow *)keyWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

+ (UIWindow *)mainWindow
{
    return [[UIApplication sharedApplication].delegate window];
}

+ (CGFloat)curHeight
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return [ViewUtil screenHeight];
    }
    else {
        return [ViewUtil screenWidth];
    }
}

+ (CGFloat)curWidth
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return [ViewUtil screenWidth];
    }
    else {
        return [ViewUtil screenHeight];
    }
}

+ (void)setScreenBrightness:(CGFloat)aBrightness;
{
    if ((aBrightness > 1.0) || (aBrightness < 0.0))
        return;
    float alp = 1.0 - (0.7 * aBrightness + 0.3);
    [gBrightnessWindow setAlpha:alp];
}

+ (void)tempTopScreenBrightness
{
    [gBrightnessWindow setAlpha:0.0];
}


#pragma mark - 图片操作
// ipad : snap current page view ,then plus a logo
// iphone : snap at most 5 pages view, then plus a logo
// 水印如果加到view外面，需要设置backgroundColor,如果加到图片里面，backgroundColor设为空。
+ (UIImage *)snapImageFromView:(UIView *)aView withLogoImage:(UIImage *)aLogoImage logoTitleColor:(UIColor *)aLogoColor backgroundColor:(UIColor *)aBackgoundColor needMark:(BOOL)aNeedMark
{
#ifdef BUILD_FOR_IPDA
    CGFloat bottomGap = 101.0f;
#else
    CGFloat bottomGap = 51.0f;
#endif
    
    if (aBackgoundColor == nil) {
        bottomGap = 0.0f;
    }
    
    CGSize size = CGSizeMake(aView.bounds.size.width, aView.bounds.size.height + bottomGap);
    
    // ----------  draw begin ----------
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw back color
    if (aBackgoundColor)
    {
        [aBackgoundColor set];
        CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width+1, size.height+1));//防止黑边
    }
    
    // draw view
    [aView.layer renderInContext:context];
    
    if (aNeedMark)
    {
#ifdef BUILD_FOR_IPDA
        CGRect rect = CGRectMake((aView.bounds.size.width - aLogoImage.size.width)/2.0,size.height - 70.0f, aLogoImage.size.width,aLogoImage.size.height);
        [aLogoImage drawInRect:rect];
#else
            // draw logo
        CGRect rect = CGRectMake(13.0f, size.height - 37.0f, aLogoImage.size.width, aLogoImage.size.height);
        [aLogoImage drawInRect:rect];
        
        // draw label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"10万好书、杂志随心订";
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = aLogoColor;
#endif
    }
    
    // get image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // ----------  draw end ----------
    
    return image;
}

+ (NSString *)compatibleImageName:(NSString *)aImageName
{
    return nil;
//    if (kIsRetina4Inch)
//    {
//        return [NSString stringWithFormat:@"%@-568h",aImageName];
//    }
//    else
//    {
//        return aImageName;
//    }
}

+ (UIImage *)noScaleImageFromView:(UIView *)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 1.0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromView:(UIView *)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 0.0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromView:(UIView *)theView inRect:(CGRect)aRect {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, theView.opaque, NO);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(aRect.origin.x*scale, aRect.origin.y*scale,
                             aRect.size.width*scale, aRect.size.height*scale);
    CGImageRef cgImg = CGImageCreateWithImageInRect([theImage CGImage], rect);
    UIImage* aImg = [UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    return aImg;
}

+ (UIImage *)CovertToPng:(UIImage *)im withLocalpath:(NSString *)localPath
{
	NSData* data = [NSData dataWithContentsOfFile:localPath];
	NSUInteger len = [data length];
	if (data == nil || len < 2)
	{
		return im;
	}
	
	Byte *byteData = (Byte*)malloc(len);
	memcpy(byteData, [data bytes], len);
	Byte b0 = byteData[0];
	Byte b1 = byteData[1];
	
	UIImage *ret = im;
	if(b0 == 66 && b1 == 77)
	{
		//fileType =@"BMP";
	}
	else if(b0 ==255 && b1 == 216)
	{
		//fileType =@"JPG";
	}
	else if(b0 ==137 && b1 == 80)
	{
		//fileType =@"PNG";
	}
	else if(b0==71 && b1 == 73)
	{
		//fileType=@"GIF";
		UIImage *myImage = [UIImage imageWithCGImage:im.CGImage];
		NSData *pngData = UIImagePNGRepresentation(myImage);
		//NSData *jpgData = UIImageJPEGRepresentation(myImage);
		UIImage *pngIm = [UIImage imageWithData:pngData];
		ret =  pngIm;
	}
	
	free(byteData);
	return ret;
}

+ (NSURL *)scaledUrlFromOriginalUrl:(NSString *)oUrl size:(CGSize)aSize
{
    NSString *scaledUrlString = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/!%.0fx%.0fr/format/jpg", oUrl, aSize.width*2, aSize.height*2];
    
//    if ([oUrl hasSuffix:@"gif"]) {
//        scaledUrlString = [NSString stringWithFormat:@"%@/format/jpg", scaledUrlString];
//    }
    
    NSURL *url = [NSURL URLWithString:scaledUrlString];
    return url;
}

+ (NSString *)scaledUrlStringFromOriginalUrl:(NSString *)oUrl size:(CGSize)aSize
{
    NSString *scaledUrlString = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/!%.0fx%.0fr/format/jpg", oUrl, aSize.width*2, aSize.height*2];
    return scaledUrlString;
}

+ (NSString *)scaledUserPhotoUrlStringFromOriginalUrl:(NSString *)oUrl
{
    return [ViewUtil scaledUrlStringFromOriginalUrl:oUrl size:CGSizeMake(64*2, 64*2)];
}

+ (NSString *)scaledUrlStringFromOriginalUrl:(NSString *)oUrl size:(CGSize)aSize  withBlur:(BOOL)blur
{
    NSString *scaledUrlString = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/%.0fx%.0f/format/jpg/blur/30x20", oUrl, aSize.width*2, aSize.height*2];
    return scaledUrlString;
}

+ (NSString *)originalUrlStringFromUrl:(NSString *)anUrl
{
    NSString *originalUrl = anUrl;
    NSRange range = [anUrl rangeOfString:@"?imageMogr2"];
    if(range.location != NSNotFound) {
        originalUrl = [anUrl substringToIndex:range.location];
    }
    return originalUrl;
}

+ (UIImage *)rotateImage:(UIImage *)aImage
{
    UIImageOrientation destOrientation = UIImageOrientationUp;
    switch (aImage.imageOrientation) {
        case UIImageOrientationUp:
            destOrientation = UIImageOrientationRight;
            break;
        case UIImageOrientationDown:
            destOrientation = UIImageOrientationLeft;
            break;
        case UIImageOrientationLeft:
            destOrientation = UIImageOrientationUp;
            break;
        case UIImageOrientationRight:
            destOrientation = UIImageOrientationDown;
            break;
        case UIImageOrientationUpMirrored:
            destOrientation = UIImageOrientationRightMirrored;
            break;
        case UIImageOrientationDownMirrored:
            destOrientation = UIImageOrientationLeftMirrored;
            break;
        case UIImageOrientationLeftMirrored:
            destOrientation = UIImageOrientationUpMirrored;
            break;
        case UIImageOrientationRightMirrored:
            destOrientation = UIImageOrientationDownMirrored;
            break;
        default:
            break;
    }
    UIImage * resultImage = [[UIImage alloc] initWithCGImage: aImage.CGImage
                                                       scale: 1.0
                                                 orientation: destOrientation];
    
    return resultImage;
}

#pragma mark - 视图显示操作
+ (UIImageView *)showImage:(UIImage *)aImage inView:(UIView *)aView withTag:(int)aTag;
{
    UIImageView *imageView = nil;
    if (aView) {
        imageView = [[UIImageView alloc] initWithImage:aImage];
        imageView.tag = aTag;
        imageView.frame = aView.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [aView addSubview:imageView];
    }
    return imageView;
}

+ (UIView *)addViewInView:(UIView *)aView withTag:(int)aTag;
{
    UIView *view = nil;
    if (aView) {
        view = [[UIView alloc] initWithFrame:aView.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.tag = aTag;
        [aView addSubview:view];
    }
    return view;
}

+ (void)removeViewOfTag:(int)aTag inView:(UIView *)aView
{
    UIView *removeView = [aView viewWithTag:aTag];
    if (removeView) {
        [removeView removeFromSuperview];
    }
}

+ (UISwipeGestureRecognizer *)addSwipeRightGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *swipeR = nil;
    if (aView) {
        swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
        [swipeR setDirection:UISwipeGestureRecognizerDirectionRight];
        [aView addGestureRecognizer:swipeR];
    }
    return swipeR;
}

+ (UISwipeGestureRecognizer *)addSwipeLeftGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *swipeL = nil;
    if (aView) {
        swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
        [swipeL setDirection:UISwipeGestureRecognizerDirectionLeft];
        [aView addGestureRecognizer:swipeL];
    }
    return swipeL;
}

+ (UITapGestureRecognizer *)addSingleTapGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = nil;
    if (aView) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [aView addGestureRecognizer:tap];
        [aView setUserInteractionEnabled:YES];
    }
    return tap;
}

+ (void)removeAllGestureOfView:(UIView *)aView
{
    while (aView.gestureRecognizers.count >0) {
        UIGestureRecognizer *gesture = aView.gestureRecognizers.lastObject;
        [aView removeGestureRecognizer:gesture];
    }
}

#pragma mark - UILable自适应文字高度
+ (CGFloat)updateLabel:(UILabel *)label withText:(NSString *)string
{
    if (string!=nil) label.text = string;
    CGFloat width = label.frame.size.width;
    CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:label.lineBreakMode].height;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, width, height);
    return height;
}

+ (CGFloat)updateLabel:(UILabel *)label withText:(NSString *)string contstrainedSize:(CGSize)size
{
    if (string!=nil) label.text = string;
    CGFloat width = size.width;
    CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:label.lineBreakMode].height;
    label.frame = CGRectMake((int)label.frame.origin.x, (int)label.frame.origin.y, (int)width, (int)height);
    return height;
}

#pragma mark - 字体

+ (void)updateFontOfView:(UIView *)aView
{
//    UIFont *font = [UIFont fontWithName:[[NRFontManager sharedManager] currentFontDesc] size:17.0f];
//    if (font == nil)
//    {
//        return;
//    }
//
//    if ([aView isKindOfClass:[UILabel class]])
//    {
//        UILabel *label = (UILabel *)aView;
//        [label setFont:[font fontWithSize:label.font.pointSize]];
//    }
//    else if ([aView isKindOfClass:[UIButton class]])
//    {
//        UILabel *label = [(UIButton *)aView titleLabel];
//        [label setFont:[font fontWithSize:label.font.pointSize]];
//    }
//    else if ([aView isKindOfClass:[UITextView class]])
//    {
//        UITextView *textView = (UITextView *)aView;
//        [textView setFont:[font fontWithSize:textView.font.pointSize]];
//    }
//    else if ([aView isKindOfClass:[UITextField class]])
//    {
//        UITextField *textField = (UITextField *)aView;
//        [textField setFont:[font fontWithSize:textField.font.pointSize]];
//    }
//    else if ([aView isKindOfClass:[UITableView class]])
//    {
//        return;
//    }
//    else
//    {
//        for (UIView *subView in aView.subviews)
//        {
//            [ViewUtil updateFontOfView:subView];
//        }
//    }
}

#pragma mark - load view from nib file
+ (id)loadViewFromeNib:(NSString *)nibName {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if ([views count] > 0) {
        return [views objectAtIndex:0];
    }
    return nil;
}

#pragma mark - 视图大小位置的一些调整
+ (void)extentView:(UIView *)view byOffsetX:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.size.width += offset;
    view.frame = frame;
}

+ (void)extentView:(UIView *)view byOffsetY:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.size.height += offset;
    view.frame = frame;
}

+ (void)translateView:(UIView *)view byOffsetY:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.origin.y += offset;
    view.frame = frame;
}

+ (void)translateView:(UIView *)view byOffsetX:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.origin.x += offset;
    view.frame = frame;
}

+ (void)resetView:(UIView *)aView ofWidth:(CGFloat)aWidth
{
    CGRect frame = aView.frame;
    frame.size.width = aWidth;
    aView.frame = frame;
}

+ (void)translateView:(UIView *)aView toPoint:(CGPoint)aPoint
{
    CGRect frame = aView.frame;
    frame.origin = aPoint;
    aView.frame = frame;
}

#pragma mark - 网页操作
+ (UIScrollView *)scrollViewOfWebView:(UIWebView *)aWebView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        return aWebView.scrollView;
    }
	for(UIView *view in [aWebView subviews]) {
		if([view isKindOfClass:[UIScrollView class]]) {
			return (UIScrollView *)view;
		}
	}
    return nil;
}

+ (void)hideShadowOfWebView:(UIWebView *)aWebView
{
    // clear shadow view under scroll view
    for(UIView *view in [[[aWebView subviews] objectAtIndex:0] subviews]) {
		if([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
		}
	}
    aWebView.opaque = NO;
    aWebView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - other
+ (UIColor *)parserFromString:(NSString *)aColorString
{
    if (aColorString.length == 0) {
        return [UIColor colorWithWhite:247.0/255.0 alpha:1.0];
    }
    int start = 0;
    if ([aColorString hasPrefix:@"#"]) {
        start = 1;
    }
    int len = aColorString.length/3;
    unsigned int a[3];
    for (int i=0; i<3; i++) {
        NSRange range;
        range.location = start + i*len;
        range.length = len;
        NSString *str = [aColorString substringWithRange:range];
        [[NSScanner scannerWithString:str] scanHexInt:a+i];
        if (len == 1) {
            a[i] *= 17;
        }
    }
    
    return [UIColor colorWithRed:a[0]/255.0 green:a[1]/255.0 blue:a[2]/255.0 alpha:1.0];
}


+ (UIImage *)scaledImage:(UIImage *)aImage ofSize:(CGSize)aSize
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, aSize.width, aSize.height));
    CGImageRef imageRef = aImage.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(aSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, aSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)customPresentModalViewAnimationFromViewController:(UIViewController *)aFromViewController toViewController:(UIViewController *)aToViewController
{
    
    UIView *maskView = [ViewUtil addViewInView:aFromViewController.view withTag:0];
    [maskView setBackgroundColor:[UIColor blackColor]];
    [maskView setAlpha:0.0f];
    
    [aFromViewController.view.window setBackgroundColor:[UIColor blackColor]];
    [aFromViewController.parentViewController.view setBackgroundColor:[UIColor blackColor]];
    CATransform3D orignTrans = aFromViewController.view.layer.transform;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [maskView setAlpha:0.9f];
        [aFromViewController.view.layer setTransform:CATransform3DConcat(orignTrans, CATransform3DTranslate(CATransform3DMakePerspective(100.0f), 0.0f, 0.0f, -5.0f)) ];
    } completion:^(BOOL finished) {
        [aFromViewController.view.layer setTransform:orignTrans];
        [maskView removeFromSuperview];
        [aFromViewController.view.window setBackgroundColor:[UIColor clearColor]];
        [aFromViewController.parentViewController.view setBackgroundColor:[UIColor clearColor]];
    }];
    
    [aToViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [aFromViewController presentModalViewController:aToViewController animated:YES];
    [aFromViewController presentViewController:aToViewController animated:YES completion:nil];

}

+ (void)customDissmissModalViewAnimationFromViewController:(UIViewController *)aFromViewController
{
    if (aFromViewController.modalTransitionStyle != UIModalTransitionStyleCoverVertical) {
        [aFromViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    // 获取 dismiss to view controller
    UIViewController *aToViewController = nil;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 5.0) {
        aToViewController = aFromViewController.presentingViewController;
    }
    else {
        aToViewController = aFromViewController.parentViewController;
    }
    
    if (aFromViewController.navigationController!=nil) {
        aFromViewController = aFromViewController.navigationController;
        aToViewController = aFromViewController.parentViewController;
    }
    if (aToViewController == nil) {
        aToViewController = aFromViewController.view.window.rootViewController;
    }
    else if ([aToViewController isKindOfClass:[UITabBarController class]]) {
        aToViewController = [(UITabBarController *)aToViewController selectedViewController];
    }
    
    if ([aToViewController isKindOfClass:[UINavigationController class]]) {
        aToViewController = [(UINavigationController *)aToViewController topViewController];
    }
    
    if (aToViewController.modalViewController != aFromViewController) {
        [aFromViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [aFromViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    UIView *maskView = [ViewUtil addViewInView:aToViewController.view withTag:0];
    [maskView setBackgroundColor:[UIColor blackColor]];
    [maskView setAlpha:0.9f];

    // 动画
    [aToViewController.view.window setBackgroundColor:[UIColor blackColor]];
    [aToViewController.parentViewController.view setBackgroundColor:[UIColor blackColor]];
    CATransform3D orignTrans = aToViewController.view.layer.transform;
    [aToViewController.view.layer setTransform:CATransform3DConcat(orignTrans, CATransform3DTranslate(CATransform3DMakePerspective(100.0f), 0.0f, 0.0f, -5.0f)) ];
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [maskView setAlpha:0.0f];
        [aToViewController.view.layer setTransform:orignTrans];
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        [aToViewController.view.window setBackgroundColor:[UIColor clearColor]];
        [aToViewController.parentViewController.view setBackgroundColor:[UIColor clearColor]];
    }];

}

+ (void)addPushAnimationToView:(UIView *)aView aIsRight:(BOOL)aIsRight
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    if (aIsRight)
    {
        transition.subtype = kCATransitionFromRight;
    }
    else
    {
        transition.subtype = kCATransitionFromLeft;
    }
    [aView.layer addAnimation:transition forKey:@"viewUtilPushAnimation"];
}
+ (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p2.y,2));
}

#pragma mark - UIScrollView
+ (NSInteger)horizontalPageNumber:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    CGSize viewSize = scrollView.bounds.size;
    
    NSInteger horizontalPage = MAX(0.0, contentOffset.x / viewSize.width);
    return horizontalPage;
}

@end

#pragma mark - 调节亮度的window

@implementation BrightnessWindow
+ (BrightnessWindow *)initGlobalInstance
{
    if (gBrightnessWindow == nil) {
        gBrightnessWindow = [[BrightnessWindow alloc] initWithFrame:CGRectMake(0.0, 0.0, [ViewUtil screenWidth], [ViewUtil screenHeight])];
        
        [gBrightnessWindow setWindowLevel:UIWindowLevelStatusBar+1];
        [gBrightnessWindow setUserInteractionEnabled:NO];
        [gBrightnessWindow setHidden:NO];
        
        [gBrightnessWindow setBackgroundColor:[UIColor blackColor]];
        [gBrightnessWindow setAlpha:0.0f];
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSNumber *number = [ud objectForKey:SettingUserBrightness];
//        if (number) {
//            [ViewUtil setScreenBrightness:[number floatValue]];
//        }
//        else {
//            [ViewUtil setScreenBrightness:1.0];
//        }
        
        [[NSNotificationCenter defaultCenter] addObserver:gBrightnessWindow selector:@selector(keyWindowChangedNotification:) name:UIWindowDidBecomeKeyNotification object:nil];
    }
    return gBrightnessWindow;
}

+ (void)uninitGlobalInstance
{
    [[NSNotificationCenter defaultCenter] removeObserver:gBrightnessWindow];
    gBrightnessWindow = nil;
}

- (void)keyWindowChangedNotification:(NSNotification *)aNotification
{
    if (gBrightnessWindow == [aNotification object]) {
        [self.customKeyWindow makeKeyAndVisible];
    }
}
@end
