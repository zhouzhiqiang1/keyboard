//
//  YDCommentInputView.m
//  yxtk
//
//  Created by Aren on 16/3/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "YDCommentInputView.h"
#import "ViewUtil.h"
#import "YDEmojiCell.h"

//static const CGFloat kEmojiInputViewHeight = 150;
static const CGFloat kBottomHeight = 32;
static const CGFloat kInputBarHeight = 44;
static const CGFloat kNumberOfCellPerRow = 7;
static const CGFloat kNumberOfLinePerPage = 3;
@implementation YDCommentInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.commentInputTextField.returnKeyType = UIReturnKeySend;
    self.commentInputTextField.delegate = self;
    [self.commentInputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YDEmojiCell"bundle:nil] forCellWithReuseIdentifier:@"YDEmojiCell"];
    [self initEmojiDataSource];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initEmojiDataSource
{
    self.emojiDataSource = @[@"😄",@"😃",@"😀",@"😊",@"☺️",@"😉",@"😍",
                             @"😘",@"😚",@"😗",@"😙",@"😜",@"😝",@"😛",
                             @"😳",@"😁",@"😔",@"😌",@"😒",@"😞",@"del",
                             @"😣",@"😢",@"😂",@"😭",@"😪",@"😥",@"😰",
                             @"😅",@"😓",@"😩",@"😫",@"😨",@"😱",@"😠",
                             @"😡",@"😤",@"😖",@"😆",@"😋",@"😷",@"del",
                             @"😎",@"😴",@"😵",@"😲",@"😟",@"😦",@"😧",
                             @"😈",@"👿",@"😮",@"😬",@"😐",@"😕",@"😯",
                             @"😶",@"😇",@"😏",@"😑",@"del"];
    
    self.pageControl.numberOfPages = ceilf(self.emojiDataSource.count/(kNumberOfCellPerRow*kNumberOfLinePerPage*1.0));
}

- (void)showInputView
{
    self.inputBottomViewHeight = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = window.bounds;
    [self.commentInputTextField becomeFirstResponder];
}

- (void)hideInputView
{
    self.inputBottomViewHeight = 0;
    [self.commentInputTextField resignFirstResponder];
    self.commentInputTextField.text = @"";
    self.commentInputTextField.placeholder = nil;
    CGRect rect = self.frame;
    rect.origin.y = [ViewUtil screenHeight];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
        [self removeFromSuperview];
    }];
    if ([self.delegate respondsToSelector:@selector(didHideCommentInputView:)]) {
        [self.delegate didHideCommentInputView:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(commentInputView:onSendText:)]) {
            NSString *content = self.commentInputTextField.text;
            [self hideInputView];
            [self.delegate commentInputView:self onSendText:content];
        } else {
            [self hideInputView];
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)aTextField
{
    if (aTextField.text.length > 0) {
//        NSString *lastCharactar = [aTextField.text substringFromIndex:aTextField.text.length - 1];
//        if ([lastCharactar isEqualToString:@"@"]) {
//            if ([self.delegate respondsToSelector:@selector(didInputAtFromCommentInputView:)]) {
//                [self.delegate didInputAtFromCommentInputView:self];
//            }
//        }
    }
}

#pragma mark - UICollectionView Delegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.emojiDataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    static NSString *cellIdentifier = @"YDEmojiCell";
    YDEmojiCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *str = [self.emojiDataSource objectAtIndex:row];
    if ([str isEqualToString:@"del"]) {
        cell.deleteImageView.hidden = NO;
        cell.emojiLabel.text = nil;
    } else {
        cell.emojiLabel.text = [self.emojiDataSource objectAtIndex:row];
        cell.deleteImageView.hidden = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    CGSize cellSize = CGSizeMake(1, 1);
//    CGFloat maxWidth = collectionView.frame.size.width;
    cellSize.width = collectionView.frame.size.width/(kNumberOfCellPerRow*1.0);
    cellSize.height = cellSize.width;
    return cellSize;
//    return [YDEmojiCell sizeForCell];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *emojiStr = [self.emojiDataSource objectAtIndex:row];
    if ([emojiStr isEqualToString:@"del"]) {
        if (self.commentInputTextField.text.length == 0) {
            return;
        } else {
            NSString *str = self.commentInputTextField.text;
            NSUInteger lastCharIndex = [str length] - 1;
            NSRange rangeOfLastChar = [str rangeOfComposedCharacterSequenceAtIndex:lastCharIndex];
            self.commentInputTextField.text = [str substringToIndex:rangeOfLastChar.location];
        }
    } else {
        if (self.commentInputTextField.text.length == 0) {
            self.commentInputTextField.text = emojiStr;
        } else {
            self.commentInputTextField.text = [NSString stringWithFormat:@"%@%@", self.commentInputTextField.text, emojiStr];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = [ViewUtil horizontalPageNumber:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate)
    {
        self.pageControl.currentPage = [ViewUtil horizontalPageNumber:scrollView];
    }
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (!self.window) {
        return;//如果当前vc不是堆栈的top vc，则不需要监听
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    [self layoutIfNeeded];
    NSLog(@"------> end frame height %.2f",endFrame.origin.y);
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    BOOL ios7 = ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0);
    //IOS7的横屏UIDevice的宽高不会发生改变，需要手动去调整
    toFrame.origin.y -= self.inputBottomViewHeight;
    if (ios7 && (orientation == UIDeviceOrientationLandscapeLeft
                 || orientation == UIDeviceOrientationLandscapeRight)) {
        if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.width) {
            [self willShowBottomHeight:0];
        }else{
            [self willShowBottomHeight:toFrame.size.width];
        }
    }else{
        if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
            [self willShowBottomHeight:0];
        }else{
            [self willShowBottomHeight:toFrame.size.height];
        }
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = kInputBarHeight + bottomHeight;
    CGFloat screenHeight = [ViewUtil screenHeight];
    
    self.inputviewHeightConstraint.constant = toHeight;
//    self.inputviewBottomConstraint.constant = 
    [self layoutIfNeeded];
    
//    CGRect toFrame = CGRectMake(fromFrame.origin.x, screenHeight - 64 - toHeight, fromFrame.size.width, toHeight);
//    self.frame = toFrame;
}

#pragma mark - Tap Handle
- (void)handleTap:(UIGestureRecognizer *)aGestureRecognizer
{
    [self hideInputView];
}

#pragma mark - Action

- (IBAction)onEmotionButtonAction:(id)sender {
    CGFloat cellWidth = self.collectionView.frame.size.width/(kNumberOfCellPerRow*1.0);
    CGFloat collectionViewHeight = cellWidth*kNumberOfLinePerPage + kBottomHeight + 8;
    self.inputBottomViewHeight = collectionViewHeight;
    [self.commentInputTextField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        [self willShowBottomHeight:_inputBottomViewHeight];
    }];
}

- (IBAction)onSendButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commentInputView:onSendText:)]) {
        NSString *content = self.commentInputTextField.text;
        
        [self hideInputView];
        
        [self.delegate commentInputView:self onSendText:content];
    } else {
        [self hideInputView];
    }
}

@end
