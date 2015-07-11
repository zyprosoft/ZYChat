//
//  GJCUCaptureDemoViewController.m
//  GJCoreUserInterface
//
//  Created by ZYVincent on 15-1-23.
//  Copyright (c) 2015年 ganji. All rights reserved.
//

#import "GJCUCaptureDemoViewController.h"
#import "GJCUCaptureViewController.h"

@interface GJCUCaptureDemoViewController ()<GJCUCaptureViewControllerDelegate>

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation GJCUCaptureDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *takePhotoBtn = [TVGDebugQuickUI buttonAddOnView:self.view title:@"拍照" target:self selector:@selector(takePhoto)];
    takePhotoBtn.gjcf_top = 30 + 44;
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.gjcf_top = takePhotoBtn.gjcf_bottom + 10;
    self.imageView.gjcf_width = GJCFSystemScreenWidth - 20;
    self.imageView.gjcf_left = 10.f;
    self.imageView.gjcf_height = GJCFSystemScreenHeight - takePhotoBtn.gjcf_bottom - 10;
    [self.view addSubview:self.imageView];
}

- (void)takePhoto
{
    GJCUCaptureViewController *captureController = [[GJCUCaptureViewController alloc]init];
    captureController.delegate = self;
    [self presentViewController:captureController animated:YES completion:nil];
    
}

- (void)captureViewController:(GJCUCaptureViewController *)captureViewController didFinishChooseMedia:(NSDictionary *)mediaInfo
{
    UIImage *image = [mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
