//
//  XNDefectView.m
//  XNManager
//
//  Created by Carlson Lee on 2017/5/22.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "XNDefectView.h"
#import <UIImage+GIF.h>

@interface XNDefectView ()

@property(nonatomic, strong)UIImageView* dImage;
@property(nonatomic, strong)UILabel* dLabel;
@property(nonatomic, strong)UIButton* dBtn;

@end

@implementation XNDefectView

- (UIImageView *)dImage
{
    if(!_dImage){
        _dImage = [[UIImageView alloc]init];
        [self addSubview:_dImage];
        _dImage.animationDuration = 1.f;
        _dImage.animationRepeatCount = CGFLOAT_MAX;
    }
    return _dImage;
}

- (UILabel *)dLabel
{
    XN_NEW_LABEL(_dLabel, nil, UIColorFromRGB(0x323232), XNFont(16, FONT_TYPE_REGULAR), NSTextAlignmentCenter, 0, self)
}

- (UIButton *)dBtn
{
    if(!_dBtn){
        _dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_dBtn];
        [_dBtn.titleLabel setFont:XNFont(16, FONT_TYPE_REGULAR)];
        [_dBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_dBtn setTitleColor:UIColorFromRGB(0xd8d8d8) forState:UIControlStateHighlighted];
        [_dBtn setBackgroundColor:UIColorFromRGB(0x356bfe)];
        [_dBtn.layer setCornerRadius:3.0];
        [_dBtn addTarget:self action:@selector(btnResponse) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dBtn;
}

- (void)setDImgStr:(NSString *)dImgStr
{
    _dImgStr = dImgStr;
    if(_dImgStr && _dImgStr.length>0){
        [MyTool arrayImageWithName:_dImgStr block:^(NSArray *images) {
            self.dImage.animationImages = images;
            [self.dImage startAnimating];
        }];
    }
}

- (void)setDLabStr:(NSString *)dLabStr
{
    _dLabStr = dLabStr;
    if(_dLabStr && _dLabStr.length>0){
        self.dLabel.text = _dLabStr;
    }
    [self setNeedsLayout];
}

- (void)setDBtnStr:(NSString *)dBtnStr
{
    _dBtnStr = dBtnStr;
    if(_dBtnStr && _dBtnStr.length>0){
        [self.dBtn setTitle:_dBtnStr forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
}

- (void)setType:(DEFECT_TYPE)type
{
    _type = type;
    
    switch (_type) {
        case DEFECT_TYPE_DEFAULT:{
            self.dImgStr = @"defect_null";
            self.dLabStr = @"未找到符合条件的贷款产品";
//            self.dBtnStr = @"清空筛选";
        }
            break;
        case DEFECT_TYPE_NET_ERROE:{
            self.dImgStr = @"defect_net";
            self.dLabStr = @"网络不给力";
            self.dBtnStr = @"重新加载";
        }
            break;
        case DEFECT_TYPE_LOAD_ERROR:{
            self.dImgStr = @"defect_fail";
            self.dLabStr = @"加载失败";
            self.dBtnStr = @"重新加载";
        }
            break;
        case DEFECT_TYPE_NO_VALUE:{
            self.dImgStr = @"defect_null";
            self.dLabStr = @"暂无数据";
            self.dBtnStr = @"重新加载";
        }
            break;
        case DEFECT_TYPE_NO_ATTENTION:{
            self.dImgStr = @"defect_null";
            self.dLabStr = @"您还没关注过别人";
        }
            break;
        case DEFECT_TYPE_NO_FANS:{
            self.dImgStr = @"defect_null";
            self.dLabStr = @"您还没粉丝";
        }
        case DEFECT_TYPE_NO_MESSAGE:{
            self.dImgStr = @"defect_null";
            self.dLabStr = @"您还没任何消息";
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (instancetype)initWithType:(DEFECT_TYPE )type
{
    if(self = [super init]){
        self.type = type;
        [self setHidden:YES];
    }
    return self;
}

- (instancetype)initWithDefectImgStr:(NSString* )imgStr tStr:(NSString* )tStr btnStr:(NSString* )bStr
{
    if(self = [super init]){
        self.dImgStr = imgStr;
        self.dLabStr = tStr;
        self.dBtnStr = bStr;
    }
    return self;
}

- (void)showDefect:(BOOL)isShow block:(void(^)())block
{
    [self setHidden:!isShow];
    _block = block;
}

- (void)btnResponse
{
    [self setHidden:YES];
    if(_block)_block();
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize isz = CGSizeZero;
    CGSize lsz = CGSizeZero;
    CGSize bsz = CGSizeZero;
    if(_dImgStr && _dImgStr.length>0){
        isz = CGSizeMake(75*ScaleX, 50*ScaleX);
    }
    if(_dLabStr && _dLabStr.length>0){
        lsz = XNSize(_dLabStr, XNFont(16, FONT_TYPE_REGULAR), CGSizeMake(BOUNDS_WIDTH-80*ScaleX, CGFLOAT_MAX));
    }
    if(_dBtnStr && _dBtnStr.length>0){
        bsz = XNSize(_dBtnStr, XNFont(16, FONT_TYPE_REGULAR), CGSizeMake(CGFLOAT_MAX, 30));
        bsz.width+=40;
    }
    
    self.dImage.frame = CGRectMake((BOUNDS_WIDTH-isz.width)/2, (BOUNDS_HEIGHT-isz.height-lsz.height-bsz.height-35*ScaleX)/2, isz.width, isz.height);
    self.dLabel.frame = CGRectMake((BOUNDS_WIDTH-lsz.width)/2, CGRectGetMaxY(self.dImage.frame)+5*ScaleX, lsz.width, lsz.height);
    self.dBtn.frame = CGRectMake((BOUNDS_WIDTH-bsz.width)/2, CGRectGetMaxY(self.dLabel.frame)+30*ScaleX, bsz.width, 30*ScaleX);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
