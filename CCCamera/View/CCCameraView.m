//
//  CCCameraView.m
//  CCCamera
//
//  Created by 佰道聚合 on 2017/7/5.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "CCCameraView.h"
#import "UIView+CCHUD.h"

@interface CCCameraView()

@property(nonatomic, assign) NSInteger type; // 1：拍照 2：视频
@property(nonatomic, strong) CCVideoPreview *previewView;
@property(nonatomic, strong) UIView *topView;      // 上面的bar
@property(nonatomic, strong) UIView *bottomView;   // 下面的bar

@property(nonatomic, strong) UIView *tokenBottomView;   // 拍照后下面的bar
@property (nonatomic, strong) UIButton *drapButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property(nonatomic, strong) UIView *focusView;    // 聚焦动画view
@property(nonatomic, strong) UIView *exposureView; // 曝光动画view

@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UIButton *torchBtn;
@property(nonatomic, strong) UIButton *flashBtn;
@property(nonatomic, strong) UIButton *photoBtn;

@end

@implementation CCCameraView

-(instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(frame.size.height>164 || frame.size.width>374, @"相机视图的高不小于164，宽不小于375");
    self = [super initWithFrame:frame];
    if (self) {
        _type = 1;
        [self setupUI];
    }
    return self;
}

-(UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, navigationBarHeight)];
        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

-(UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 160, self.width, 160)];
        _bottomView.backgroundColor = [UIColor blackColor];
    }
    return _bottomView;
}

- (UIView *)tokenBottomView {
    if (_tokenBottomView == nil) {
        _tokenBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 160, self.width, 160)];
        _tokenBottomView.backgroundColor = [UIColor blackColor];
        _tokenBottomView.hidden = YES;
    }
    return _tokenBottomView;
}

- (UIButton *)drapButton {
    if (!_drapButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"imagePicker_drap"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(drapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _drapButton = button;
    }
    return _drapButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"imagePicker_confirm"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _confirmButton = button;
    }
    return _confirmButton;
}

- (UIImageView *)photoImageView {
    
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, self.width, self.height - navigationBarHeight - 160)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        _photoImageView.hidden = YES;
    }
    
    return _photoImageView;
    
}

-(UIView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150, 150.0f)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = [UIColor appBlueColor].CGColor;
        _focusView.layer.borderWidth = 5.0f;
        _focusView.hidden = YES;
    }
    return _focusView;
}

-(UIView *)exposureView{
    if (_exposureView == nil) {
        _exposureView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150, 150.0f)];
        _exposureView.backgroundColor = [UIColor clearColor];
        _exposureView.layer.borderColor = [UIColor purpleColor].CGColor;
        _exposureView.layer.borderWidth = 5.0f;
        _exposureView.hidden = YES;
    }
    return _exposureView;
}

-(UISlider *)slider{
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        _slider.alpha = 0.0;
    }
    return _slider;
}

-(void)setupUI{
    self.previewView = [[CCVideoPreview alloc]initWithFrame:CGRectMake(0, navigationBarHeight, self.width, self.height - navigationBarHeight - 160)];
    [self addSubview:self.previewView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self setupTokenBottomView];
    
    [self.previewView addSubview:self.focusView];
    [self.previewView addSubview:self.exposureView];
    [self.previewView addSubview:self.slider];

    [self addSubview:self.photoImageView];
    
    // ----------------------- 手势
    // 点击-->聚焦 双击-->曝光
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.previewView addGestureRecognizer:tap];
    [self.previewView addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];

    // 捏合-->缩放
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector(pinchAction:)];
    [self.previewView addGestureRecognizer:pinch];

    // ----------------------- UI
    // 缩放
    self.slider.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.slider.frame = CGRectMake(KDeviceWidth-50, 50, 15, 200);

    // 拍照
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"imagePicker_photo_take"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [photoButton sizeToFit];
    [self.bottomView addSubview:photoButton];
    [photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.centerX.equalTo(self.bottomView);
    }];
    
    _photoBtn = photoButton;
    
    // 照片类型
    /*UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeButton setTitle:@"照片" forState:UIControlStateNormal];
    [typeButton setTitle:@"视频" forState:UIControlStateSelected];
    [typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [typeButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    [typeButton sizeToFit];
    typeButton.center = CGPointMake(_bottomView.width-60, _bottomView.height/2);
    [self.bottomView addSubview:typeButton];*/
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont appFontWithFontSize:19.0];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton sizeToFit];
    cancelButton.center = CGPointMake(40, _bottomView.height/2);
    [self.topView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(18);
        make.bottom.equalTo(self.topView).offset(-10);
    }];
    
    // 转换前后摄像头
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:[UIImage imageNamed:@"video_ Rotate_default"] forState:UIControlStateNormal];
    [switchCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton sizeToFit];
    [self.topView addSubview:switchCameraButton];
    [switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-18);
        make.bottom.equalTo(self.topView).offset(-10);
    }];
    
    // 补光
    /*UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lightButton setTitle:@"补光" forState:UIControlStateNormal];
    [lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lightButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [lightButton addTarget:self action:@selector(torchClick:) forControlEvents:UIControlEventTouchUpInside];
    [lightButton sizeToFit];
    lightButton.center = CGPointMake(lightButton.width/2 + switchCameraButton.right+10, _topView.height/2);
    [self.topView addSubview:lightButton];
    _torchBtn = lightButton;*/
    
    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setImage:[UIImage imageNamed:@"video_light_high"] forState:UIControlStateNormal];
    [flashButton setImage:[UIImage imageNamed:@"video_light_no"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
    [flashButton sizeToFit];
    [self.topView addSubview:flashButton];
    [flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(switchCameraButton.mas_left).offset(-18);
        make.bottom.equalTo(switchCameraButton);
    }];
    
    _flashBtn = flashButton;
    
    // 重置对焦、曝光
    /*UIButton *focusAndExposureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusAndExposureButton setTitle:@"自动聚焦/曝光" forState:UIControlStateNormal];
    [focusAndExposureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [focusAndExposureButton addTarget:self action:@selector(focusAndExposureClick:) forControlEvents:UIControlEventTouchUpInside];
    [focusAndExposureButton sizeToFit];
    focusAndExposureButton.center = CGPointMake(focusAndExposureButton.width/2 + flashButton.right+10, _topView.height/2);
    [self.topView addSubview:focusAndExposureButton];*/
}

- (void)setupTokenBottomView {
    [self addSubview:self.tokenBottomView];
    
    [_tokenBottomView addSubview:self.drapButton];
    [_drapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tokenBottomView).offset(54);
        make.bottom.equalTo(self.tokenBottomView).offset(-15);
    }];
    
    [_tokenBottomView addSubview:self.confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tokenBottomView).offset(-54);
        make.bottom.equalTo(self.tokenBottomView).offset(-15);
    }];
}

#pragma mark --- action
- (void)drapButtonClick:(UIButton *)sender {
    
    _photoImageView.hidden = YES;
    
    _tokenBottomView.hidden = YES;
    
    _topView.hidden = NO;
    _bottomView.hidden = NO;
    
}

- (void)confirmButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmUseThisPhoto:)]) {
        [self.delegate confirmUseThisPhoto:self];
    }
}

- (void)photoToken {
    _topView.hidden = YES;
    _bottomView.hidden = YES;
    
    _photoImageView.hidden = NO;
    
    _tokenBottomView.hidden = NO;
}

-(void)changeTorch:(BOOL)on{
    _torchBtn.selected = on;
}

-(void)changeFlash:(BOOL)on{
    _flashBtn.selected = on;
}

-(void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    if ([_delegate respondsToSelector:@selector(zoomAction:factor:)]) {
        if (pinch.state == UIGestureRecognizerStateBegan) {
            [UIView animateWithDuration:0.1 animations:^{
                self->_slider.alpha = 1;
            }];
        } else if (pinch.state == UIGestureRecognizerStateChanged) {
            if (pinch.velocity > 0) {
                _slider.value += pinch.velocity/100;
            } else {
                _slider.value += pinch.velocity/20;
            }
            [_delegate zoomAction:self factor: powf(5, _slider.value)];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                self->_slider.alpha = 0.0;
            }];
        }
    }
}

// 聚焦
-(void)tapAction:(UIGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(focusAction:point:handle:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self runFocusAnimation:self.focusView point:point];
        [_delegate focusAction:self point:[self.previewView captureDevicePointForPoint:point] handle:^(NSError *error) {
            if (error) [self showError:error];
        }];
    }
}

// 曝光
-(void)doubleTapAction:(UIGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(exposAction:point:handle:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self runFocusAnimation:self.exposureView point:point];
        [_delegate exposAction:self point:[self.previewView captureDevicePointForPoint:point] handle:^(NSError *error) {
            if (error) [self showError:error];
        }];
    }
}

// 自动聚焦和曝光
-(void)focusAndExposureClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(autoFocusAndExposureAction:handle:)]) {
        [self runResetAnimation];
        [_delegate autoFocusAndExposureAction:self handle:^(NSError *error) {
            if (error) [self showError:error];
        }];
    }
}

// 拍照、视频
-(void)takePicture:(UIButton *)btn {
    if (self.type == 1) {
        if ([_delegate respondsToSelector:@selector(takePhotoAction:)]) {
            [_delegate takePhotoAction:self];
        }
    } else {
        if (btn.selected == YES) {
            // 结束
            btn.selected = NO;
            [_photoBtn setTitle:@"开始" forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(stopRecordVideoAction:)]) {
                [_delegate stopRecordVideoAction:self];
            }
        } else {
            // 开始
            btn.selected = YES;
            [_photoBtn setTitle:@"结束" forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(startRecordVideoAction:)]) {
                [_delegate startRecordVideoAction:self];
            }
        }
    }
}

// 取消
-(void)cancel:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(cancelAction:)]) {
        [_delegate cancelAction:self];
    }
}

// 转换拍摄类型
-(void)changeType:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.type = self.type == 1?2:1;
    if (self.type == 1) {
        [_photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    } else {
        [_photoBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    if ([_delegate respondsToSelector:@selector(didChangeTypeAction:type:)]) {
        [_delegate didChangeTypeAction:self type:self.type == 1?2:1];
    }
}

// 转换摄像头
-(void)switchCameraClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(swicthCameraAction:handle:)]) {
        [_delegate swicthCameraAction:self handle:^(NSError *error) {
            if (error) [self showError:error];
        }];
    }
}

// 手电筒
-(void)torchClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(torchLightAction:handle:)]) {
        [_delegate torchLightAction:self handle:^(NSError *error) {
            if (error) {
                [self showError:error];
            } else {
                self->_flashBtn.selected = NO;
                self->_torchBtn.selected = !self->_torchBtn.selected;
            }
        }];
    }
}

// 闪光灯
-(void)flashClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(flashLightAction:handle:)]) {
        [_delegate flashLightAction:self handle:^(NSError *error) {
            if (error) {
                [self showError:error];
            } else {
                self->_flashBtn.selected = !self->_flashBtn.selected;
                self->_torchBtn.selected = NO;
            }
        }];
    }
}

#pragma mark - Private methods
// 聚焦、曝光动画
-(void)runFocusAnimation:(UIView *)view point:(CGPoint)point {
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

// 自动聚焦、曝光动画
- (void)runResetAnimation {
    self.focusView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);
    self.exposureView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);;
    self.exposureView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.focusView.hidden = NO;
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.focusView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        self.exposureView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.focusView.hidden = YES;
            self.exposureView.hidden = YES;
            self.focusView.transform = CGAffineTransformIdentity;
            self.exposureView.transform = CGAffineTransformIdentity;
        });
    }];
}

#pragma mark --- lazy loading


@end
