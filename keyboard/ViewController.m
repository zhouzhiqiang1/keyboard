//
//  ViewController.m
//  keyboard
//
//  Created by r_zhou on 16/5/3.
//  Copyright © 2016年 r_zhous. All rights reserved.
//

#import "ViewController.h"
#import "YDCommentInputView.h"

/**
 *  消息类型
 */
typedef NS_OPTIONS(NSInteger, Comments){
    /**
     *  评论消息
     */
    CommentsMessage = 0,
    /**
     *  回复消息
     */
    ReplyCommentsMessage
};



@interface ViewController ()<YDCommentInputViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelReplyComments;
@property (strong, nonatomic) YDCommentInputView *commentInputView;

@property (strong, nonatomic)  NSString *name;/*用户*/
@property (assign, nonatomic) int message;/*消息类型*/
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name = @"R_zhou";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YDCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YDCommentInputView" owner:self options:nil];
        _commentInputView = [nib objectAtIndex:0];
        _commentInputView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _commentInputView.frame.size.height);
        //        [self.view addSubview:_commentInputView];
        _commentInputView.delegate = self;
    }
    return _commentInputView;
}


#pragma mark -- Action
- (IBAction)onCommentsBtnAction:(id)sender {
    
    self.message = CommentsMessage;
    [self.commentInputView showInputView];
}

- (IBAction)onReplyCommentsBtnAction:(id)sender {
    self.message = ReplyCommentsMessage;
    self.commentInputView.commentInputTextField.placeholder = [NSString stringWithFormat:@"%@ :",self.name];
    [self.commentInputView showInputView];
}

- (IBAction)onEmptyBtnAction:(id)sender {
    self.labelTitle.text = @"评论消息显示位置";
    self.labelReplyComments.text = @"回复评论消息显示位置";
}


#pragma mark - YDCommentInputViewDelegate
- (void)commentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText
{
    if (self.message == CommentsMessage) {
        NSString *string = [NSString stringWithFormat:@"%@: %@", self.name,aText];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(0,self.name.length)];
        
        self.labelTitle.attributedText = str;

    } else {
        NSString *string = [NSString stringWithFormat:@"%@ 回复 %@:%@", self.name,self.name,aText];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(0,self.name.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(self.name.length + 4,self.name.length)];
        self.labelReplyComments.attributedText = str;
    }
}

- (void)didHideCommentInputView:(YDCommentInputView *)anInputView
{
    //    self.commentListModel.commentInfo = nil;
}

- (void)didInputAtFromCommentInputView:(YDCommentInputView *)anInputView
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
//    YDAddressBookViewController *addressBookViewController = [storyboard instantiateViewControllerWithIdentifier:@"YDAddressBookViewController"];
//    
//    addressBookViewController.singleSelection = YES;
//    addressBookViewController.showSystem = YES;
//    addressBookViewController.hidesBottomBarWhenPushed = YES;
//    
//    __weak typeof(self)  weakSelf = self;
//    addressBookViewController.clickDoneCompletion = ^(YDAddressBookViewController *selectPersonViewController, NSArray *selectedUsers, NSArray *newSelectedUsers){
//        if( selectedUsers.count == 1 )
//        {
//            RCUserInfo *user = selectedUsers[0];
//            if (user.name.length > 0) {
//                NSString *str = weakSelf.commentInputView.commentInputTextField.text;
//                weakSelf.commentInputView.commentInputTextField.text = [NSString stringWithFormat:@"%@%@ ", str, user.name];
//            }
//        }
//        [weakSelf.commentInputView showInputView];
//    };
//    
//    [self.navigationController pushViewController:addressBookViewController animated:YES];
}



@end
