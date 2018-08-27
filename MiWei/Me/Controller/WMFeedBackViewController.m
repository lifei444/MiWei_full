//
//  WMFeedbackViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMFeedBackViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMFeedBackQuestion.h"
#import "WMFeedBackChooseQuestionViewController.h"
#import "MBProgressHUD.h"
#import "WMHTTPUtility.h"
#import "UIImageView+WebCache.h"

#define Title_X                     10

#define Question_Y                  (Navi_Height + 2)
#define Question_Height             50

#define Question_Content_X          95
#define Question_Content_Width      (Screen_Width - Question_Content_X)

#define GapBetweenFeedBackAndText   5

#define Text_Y                      (Question_Y + Question_Height + GapBetweenFeedBackAndText)
#define Text_Height                 175

#define Upload_Label_X              Title_X
#define Upload_Label_Y              (Text_Y + Text_Height)
#define Upload_Label_Width          100
#define Upload_label_Height         50

#define Upload_View_Y               (Upload_Label_Y + Upload_label_Height)
#define Upload_View_Height          100
#define Upload_View_Height2         200

#define Upload_Image_View_Width     60
#define Upload_Image_View_Height    60
#define Upload_Image_View_X1        17
#define Upload_Image_View_X2        111
#define Upload_Image_View_X3        205
#define Upload_Image_View_X4        299
#define Upload_Image_View_Y1        19
#define Upload_Image_View_Y2        119

#define GapBetweenUploadAndSubmit   50

#define Submit_X                    Title_X
#define Submit_Y                    (Upload_View_Y + Upload_View_Height + GapBetweenUploadAndSubmit)
#define Submit_Y2                   (Upload_View_Y + Upload_View_Height2 + GapBetweenUploadAndSubmit)

#define Submit_Width                (Screen_Width - Submit_X * 2)
#define Submit_Height               44

@interface WMFeedBackViewController () <UITextViewDelegate, WMFeedBackChooseQuestionDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong) WMFeedBackQuestion *question;
@property (nonatomic, strong) UIView *questionView;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *uploadLabel;
@property (nonatomic, strong) UIView *uploadView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray <NSString *> *imageFileIds;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *uploadImageViews;
@property (nonatomic, strong) UIImageView *uploadImageView;
@end

@implementation WMFeedBackViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self.view addSubview:self.questionView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.uploadLabel];
    [self.view addSubview:self.uploadView];
    [self.view addSubview:self.submitButton];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark - Target action
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)onQuestionTap {
    WMFeedBackChooseQuestionViewController *vc = [[WMFeedBackChooseQuestionViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)submit {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (!self.question) {
        [WMUIUtility showAlertWithMessage:@"请选择问题" viewController:self];
        return;
    }
    if (self.textView.text.length == 0) {
        [WMUIUtility showAlertWithMessage:@"请输入意见" viewController:self];
        return;
    }
    [dic setObject:self.question.questionId forKey:@"categoryID"];
    [dic setObject:self.textView.text forKey:@"descr"];
    if (self.imageFileIds.count > 0) {
        [dic setObject:self.imageFileIds forKey:@"images"];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMHTTPUtility jsonRequestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"/mobile/user/submitIssue"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.hud hideAnimated:YES];
                                            if (result.success) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                NSLog(@"/mobile/user/submitIssue error result is %@", result);
                                                [WMUIUtility showAlertWithMessage:@"提交失败" viewController:self];
                                            }
                                        });
                                    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"上传图片中";

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);

    [WMHTTPUtility uploadFile:data
                     response:^(WMHTTPResult *result) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.hud hideAnimated:YES];
                             if (result.success) {
                                 NSDictionary *content = result.content;
                                 NSString *fileId = content[@"fileID"];
                                 [self.imageFileIds addObject:fileId];
                                 NSUInteger count = self.uploadImageViews.count;
                                 UIImageView *modifyView = self.uploadImageViews[count - 1];
                                 modifyView.userInteractionEnabled = NO;
                                 [modifyView sd_setImageWithURL:[WMHTTPUtility urlWithPortraitId:fileId]];
                                 if (self.imageFileIds.count <= 7) {
                                     UIImageView *imageView = [[UIImageView alloc] init];
                                     CGRect rectAdd = CGRectZero;
                                     switch (self.imageFileIds.count) {
                                         case 1:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X2, Upload_Image_View_Y1, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         case 2:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X3, Upload_Image_View_Y1, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         case 3:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X4, Upload_Image_View_Y1, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         case 4:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X1, Upload_Image_View_Y2, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         case 5:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X2, Upload_Image_View_Y2, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         case 6:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X3, Upload_Image_View_Y2, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         case 7:
                                             rectAdd = WM_CGRectMake(Upload_Image_View_X4, Upload_Image_View_Y2, Upload_Image_View_Width, Upload_Image_View_Height);
                                             break;
                                             
                                         default:
                                             break;
                                     }
                                     if (self.imageFileIds.count >= 4) {
                                         self.uploadView.frame = WM_CGRectMake(0, Upload_View_Y, Screen_Width, Upload_View_Height2);
                                         self.submitButton.frame = WM_CGRectMake(Submit_X, Submit_Y2, Submit_Width, Submit_Height);
                                     }
                                     imageView.frame = rectAdd;
                                     imageView.image = [UIImage imageNamed:@"feedback_add"];
                                     imageView.userInteractionEnabled = YES;
                                     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
                                     [imageView addGestureRecognizer:singleTap];
                                     [self.uploadImageViews addObject:imageView];
                                     [self.uploadView addSubview:imageView];
                                 }
                             } else {
                                 NSLog(@"imagePickerController, upload error");
                             }
                         });
                     }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.picker.showsCameraControls = YES;
            } else {
                NSLog(@"模拟器无法连接相机");
            }
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
            
        case 1:
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - WMFeedBackChooseQuestionDelegate
- (void)onQuestionSelect:(WMFeedBackQuestion *)question {
    self.question = question;
    self.questionLabel.text = self.question.name;
    self.questionLabel.textColor = [UIColor blackColor];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length != 0;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

#pragma mark - Getters and setters
- (UIView *)questionView {
    if (!_questionView) {
        _questionView = [[UIView alloc] initWithFrame:WM_CGRectMake(0, Question_Y, Screen_Width, Question_Height)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Title_X, 0, 90, 50)];
        titleLabel.text = @"反馈问题";
        [_questionView addSubview:titleLabel];
        [_questionView addSubview:self.questionLabel];
    }
    return _questionView;
}

- (UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Question_Content_X, 0, Question_Content_Width, Question_Height)];
        if (self.question) {
            _questionLabel.text = self.question.name;
        } else {
            _questionLabel.text = @"请选择问题";
        }
        _questionLabel.textColor = [UIColor lightGrayColor];
        _questionLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onQuestionTap)];
        [_questionLabel addGestureRecognizer:singleTap];
    }
    return _questionLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:WM_CGRectMake(0, Text_Y, Screen_Width, Text_Height)];
        _textView.textContainerInset = UIEdgeInsetsMake([WMUIUtility WMCGFloatForY:13], [WMUIUtility WMCGFloatForX:Title_X], [WMUIUtility WMCGFloatForY:13], [WMUIUtility WMCGFloatForX:Title_X]);
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        [_textView addSubview:self.placeholderLabel];
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Title_X, 0, Screen_Width, 50)];
        _placeholderLabel.numberOfLines = 2;
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _placeholderLabel.text = @"感谢您对我们的关注与支持，您的宝贵意见我们将尽快改进，谢谢。";
    }
    return _placeholderLabel;
}

- (UILabel *)uploadLabel {
    if (!_uploadLabel) {
        _uploadLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Upload_Label_X, Upload_Label_Y, Upload_Label_Width, Upload_label_Height)];
        _uploadLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _uploadLabel.textColor = [WMUIUtility color:@"0x88888888"];
        _uploadLabel.text = @"上传图片";
    }
    return _uploadLabel;
}

- (UIView *)uploadView {
    if (!_uploadView) {
        _uploadView = [[UIView alloc] initWithFrame:WM_CGRectMake(0, Upload_View_Y, Screen_Width, Upload_View_Height)];
        _uploadView.backgroundColor = [WMUIUtility color:@"0xffffff"];
        [_uploadView addSubview:self.uploadImageView];
        [self.uploadImageViews addObject:self.uploadImageView];
    }
    return _uploadView;
}

- (NSMutableArray<UIImageView *> *)uploadImageViews {
    if (!_uploadImageViews) {
        _uploadImageViews = [[NSMutableArray alloc] init];
    }
    return _uploadImageViews;
}

- (UIImageView *)uploadImageView {
    if (!_uploadImageView) {
        _uploadImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(Upload_Image_View_X1, Upload_Image_View_Y1, Upload_Image_View_Width, Upload_Image_View_Height)];
        _uploadImageView.image = [UIImage imageNamed:@"feedback_add"];
        _uploadImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [_uploadImageView addGestureRecognizer:singleTap];
    }
    return _uploadImageView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Submit_X, Submit_Y, Submit_Width, Submit_Height)];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[WMUIUtility color:@"0x2b938b"]];
        [_submitButton setTitleColor:[WMUIUtility color:@"0xffffff"] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius = 5;
    }
    return _submitButton;
}

- (UIImagePickerController *)picker {
    if (_picker == nil) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = NO;
    }
    return _picker;
}

- (NSMutableArray<NSString *> *)imageFileIds {
    if (!_imageFileIds) {
        _imageFileIds = [[NSMutableArray alloc] init];
    }
    return _imageFileIds;
}

@end
