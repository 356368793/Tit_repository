//
//  ComposeViewController.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/6.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "ComposeViewController.h"
#import "AccountTool.h"
#import "EmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ComposeToolbar.h"
#import "ComposePhotoesView.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"

@interface ComposeViewController() <UITextViewDelegate,ComposeToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 输入控件 */
@property (weak, nonatomic) EmotionTextView *textView;
/** 键盘顶部的工具条 */
@property (weak, nonatomic) ComposeToolbar *toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
@property (weak, nonatomic) ComposePhotoesView *photoesView;
/** 表情键盘 */
@property (strong, nonatomic) EmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (assign, nonatomic) BOOL switchingKeyboard;
@end

@implementation ComposeViewController
#pragma mark - 懒加载
- (EmotionKeyboard *)emotionKeyboard
{
    if (_emotionKeyboard == nil) {
        self.emotionKeyboard = [[EmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = self.view.height - CGRectGetMaxY(self.toolbar.frame);
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    /** 设置导航栏 */
    [self setNavbar];
    /** 设置文本视图 */
    [self setTextView];
    /** 设置工具条 */
    [self setToolbar];
    /** 设置TextView中的PhotoesView */
    [self setPhotoesView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.textView.hasText) return;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

/**
 userInfo = {
	UIKeyboardFrameBeginUserInfoKey = NSRect: {{0, 568}, {320, 253}};
	UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 315}, {320, 253}};
	UIKeyboardAnimationDurationUserInfoKey = 0.25;
	UIKeyboardAnimationCurveUserInfoKey = 7;
 }
 }
 */

#pragma mark - 初始化方法
/**
 * 添加相册
 */
- (void)setPhotoesView
{
    ComposePhotoesView *photoesView = [[ComposePhotoesView alloc] init];
    photoesView.width = self.view.width;
    photoesView.height = 300;
    photoesView.y = 120;
    [self.textView addSubview:photoesView];
    self.photoesView = photoesView;
}

/**
 * 添加工具条
 */
- (void)setToolbar
{
    ComposeToolbar *toolbar = [[ComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.x = 0;
    toolbar.delegate = self;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

/**
 * 设置导航栏内容
 */
- (void)setNavbar
{
    //左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    // 右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.width = 200;
    titleView.height = 44;
    titleView.numberOfLines = 0;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    NSString *name = [AccountTool account].name;
    if (name) {
        NSString *str = [NSString stringWithFormat:@"发微博\n%@", name];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, 3)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else {
        self.title = @"发微博";
    }
}

/**
 * 添加输入控件
 */
- (void)setTextView
{
    EmotionTextView *textView = [[EmotionTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.alwaysBounceVertical = YES;
    textView.placeholder = @"发表新鲜事~~";
//    textView.keyboardType = UIKeyboardTypeAlphabet;
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:EmotionDidSelectNotification object:nil];
    
    // 删除文字的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:EmotionDidDeleteNotification object:nil];
    
}

#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}

/**
 *  表情被选中了
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    Emotion *emotion = notification.userInfo[SelectEmotionKey];
    
    [self.textView insertEmotion:emotion];
    
    [self textDidChange];
}

/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeyboard) return;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

/**
 * 监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - ComposeToolbar Delegate
- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButtonWithButtonType:(ComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ComposeToolbarButtonTypeCamera: // 照相
            [self openCamera];
            break;
        case ComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
        case ComposeToolbarButtonTypeMention: // @
            Log(@"Mention");
            break;
        case ComposeToolbarButtonTypeTrend: // #
            Log(@"Trend");
            break;
        case ComposeToolbarButtonTypeEmotion: // 表情
            [self switchKeyboard];
            break;
    }
}

#pragma mark - 其他方法
/**
 *  切换键盘
 */
- (void)switchKeyboard
{
    if (self.textView.inputView == nil) { // 表情键盘
        self.textView.inputView = self.emotionKeyboard;
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    self.switchingKeyboard = YES;
    
    [self.textView endEditing:YES];
    
    self.switchingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (void)cancel
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)openCamera
{
    [self openImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    [self openImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.photoesView addPhoto:info[UIImagePickerControllerOriginalImage]];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发图片
- (void)send
{
    if (self.photoesView.photoes.count) { // 发送带图片的微博
        [self sendMsgWithImage];
    } else {
        [self sendMsgWithoutImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 发布带有图片的微博
 */
- (void)sendMsgWithImage
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    

    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [self.photoesView.photoes firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"uploadImage" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 * 发布没有图片的微博
 */
- (void)sendMsgWithoutImage
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

@end
