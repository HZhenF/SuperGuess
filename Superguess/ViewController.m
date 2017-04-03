//
//  ViewController.m
//  Superguess
//
//  Created by HZhenF on 17/3/16.
//  Copyright © 2017年 筝风放风筝. All rights reserved.
//

#import "ViewController.h"
#import "model.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define font(size)  [UIFont systemFontOfSize:size]

#define selectButtonW ScreenWidth*0.09
#define selectButtonH ScreenWidth*0.09
#define selectButtonMargin  10

#define kTotalCol 7
#define kTotalRow 3

//控件之间的距离
#define controlMargin 10

@interface ViewController ()

@property(nonatomic,strong) UIImageView *backgroundImg;
//图片标签
@property(nonatomic,strong) UILabel *pageLabel;
//图片描述
@property(nonatomic,strong) UILabel *descriptionLabel;
//提示按钮
@property(nonatomic,strong) UIButton *tipsBtn;
//帮助按钮
@property(nonatomic,strong) UIButton *helpBtn;
//大图按钮
@property(nonatomic,strong) UIButton *bigPicBtn;
//下一题按钮
@property(nonatomic,strong) UIButton *nextQuestionBtn;
//中间大图按钮
@property(nonatomic,strong) UIButton *bigImage;
//答案区域View
@property(nonatomic,strong) UIView *answerView;
//选项按钮区域View
@property(nonatomic,strong) UIView *optionView;
//金币按钮
@property(nonatomic,strong) UIButton *moneyBtn;
//遮罩按钮
@property(nonatomic,strong) UIButton *btn_bat;

//数据模型
@property(nonatomic,strong)NSArray *modelArray;
//标签索引
@property(nonatomic,assign) int index;
//答案是否填满
@property(nonatomic,assign,getter=isFull) BOOL full;



@end

@implementation ViewController
//修改状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(UIButton *)btn_bat
{
    if (!_btn_bat) {
        _btn_bat = [[UIButton alloc] initWithFrame:self.view.bounds];
        _btn_bat.backgroundColor = [UIColor whiteColor];
        _btn_bat.alpha = 0.0f;
        [_btn_bat addTarget:self action:@selector(btn_batOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn_bat];
    }
    return _btn_bat;
}

-(UILabel *)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 + controlMargin,ScreenWidth,ScreenHeight*0.03)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_pageLabel];
    }
    return _pageLabel;
}

-(UIImageView *)backgroundImg
{
    if (!_bigImage) {
        _backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_backgroundImg];
    }
    return _backgroundImg;
}

-(UIButton *)moneyBtn
{
    if (!_moneyBtn) {
        _moneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.25, self.pageLabel.frame.size.height)];
        _moneyBtn.center = CGPointMake(ScreenWidth - (self.moneyBtn.frame.size.width*0.5), self.pageLabel.center.y);
        [_moneyBtn setTitle:@"100" forState:UIControlStateNormal];
        [_moneyBtn setImage:[UIImage imageNamed:@"coin"] forState:UIControlStateNormal];
        _moneyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moneyBtn.enabled = NO;
        _moneyBtn.adjustsImageWhenDisabled = NO;
//        [_moneyBtn setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:_moneyBtn];
    }
    return _moneyBtn;
}

-(UIButton *)bigImage
{
    if (!_bigImage) {
        _bigImage = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.25, CGRectGetMaxY(self.pageLabel.frame) + controlMargin, ScreenWidth*0.5, ScreenWidth*0.5)];
//        [_bigImage setBackgroundColor:[UIColor blueColor]];
        [_bigImage addTarget:self action:@selector(btn_batOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bigImage];
    }
    return _bigImage;
}

-(UIButton *)tipsBtn
{
    if (!_tipsBtn) {
        _tipsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.19, ScreenHeight*0.05)];
        _tipsBtn.center = CGPointMake(ScreenWidth*0.19*0.5, self.bigImage.center.y - 3*controlMargin);
        [_tipsBtn addTarget:self action:@selector(tipsOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_tipsBtn];
    }
    return _tipsBtn;
}

-(UIButton *)helpBtn
{
    if (!_helpBtn) {
        _helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  ScreenWidth*0.19, ScreenHeight*0.05)];
        _helpBtn.center = CGPointMake(ScreenWidth*0.19*0.5, self.bigImage.center.y + 3*controlMargin);
        [self.view addSubview:_helpBtn];
    }
    return _helpBtn;
}

-(UIButton *)bigPicBtn
{
    if (!_bigPicBtn) {
        _bigPicBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.19, ScreenHeight*0.05)];
        _bigPicBtn.center = CGPointMake(ScreenWidth*(1-0.19*0.5), self.bigImage.center.y - 3*controlMargin);
        [_bigPicBtn addTarget:self action:@selector(btn_batOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bigPicBtn];
    }
    return _bigPicBtn;
}

-(UIButton *)nextQuestionBtn
{
    if (!_nextQuestionBtn) {
        _nextQuestionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.19, ScreenHeight*0.05)];
        _nextQuestionBtn.center = CGPointMake(ScreenWidth*(1-0.19*0.5), self.bigImage.center.y + 3*controlMargin);
        [_nextQuestionBtn addTarget:self action:@selector(newQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextQuestionBtn];
    }
    return _nextQuestionBtn;
}

-(UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bigImage.frame) + controlMargin, ScreenWidth, ScreenHeight * 0.03)];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
//        [_descriptionLabel setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

-(UIView *)answerView
{
    if (!_answerView) {
        _answerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame) + 10, ScreenWidth, selectButtonH)];
//        _answerView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_answerView];
    }
    return _answerView;
}

-(UIView *)optionView
{
    if (!_optionView) {
        _optionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.answerView.frame) + controlMargin, ScreenWidth, ScreenHeight*0.25)];
//        _optionView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_optionView];
    }
    return _optionView;
}

-(NSArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [model modelArray];
    }
    return _modelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupControls];
}

-(void)setupControls
{
    
    model *question = self.modelArray[self.index];
    
    self.backgroundImg.image = [UIImage imageNamed:@"bj.jpg"];
    
    [self setupBasicInfo:question];
 
    
    [self moneyBtn];
    
    //self.bigImage Configure
    [self.bigImage setBackgroundImage:[UIImage imageNamed:@"center_img"] forState:UIControlStateNormal];
    self.bigImage.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);

    
    //self.tipsBtn Configure
    [self.tipsBtn setBackgroundImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
    [self.tipsBtn setBackgroundImage:[UIImage imageNamed:@"btn_left_highlighted"] forState:UIControlStateHighlighted];
    [self.tipsBtn setImage:[UIImage imageNamed:@"icon_tip"] forState:UIControlStateNormal];
    [self.tipsBtn setTitle:@"提示" forState:UIControlStateNormal];
    [self.tipsBtn.titleLabel setFont:font(12.0)];
    [self.tipsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //self.helpBtn Configure
    [self.helpBtn setBackgroundImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
    [self.helpBtn setBackgroundImage:[UIImage imageNamed:@"btn_left_highlighted"] forState:UIControlStateHighlighted];
    [self.helpBtn setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
    [self.helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [self.helpBtn.titleLabel setFont:font(12.0)];
    [self.helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //self.bigPicBtn Configure
    [self.bigPicBtn setBackgroundImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    [self.bigPicBtn setBackgroundImage:[UIImage imageNamed:@"btn_right_highlighted"] forState:UIControlStateHighlighted];
    [self.bigPicBtn setImage:[UIImage imageNamed:@"icon_img"] forState:UIControlStateNormal];
    [self.bigPicBtn setTitle:@"大图" forState:UIControlStateNormal];
    [self.bigPicBtn.titleLabel setFont:font(12.0)];
    [self.bigPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //self.nextQuestionBtn  Configure
    [self.nextQuestionBtn setBackgroundImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    [self.nextQuestionBtn setBackgroundImage:[UIImage imageNamed:@"btn_right_highlighted"] forState:UIControlStateHighlighted];
    [self.nextQuestionBtn setTitle:@"下一题" forState:UIControlStateNormal];
    [self.nextQuestionBtn.titleLabel setFont:font(13.0)];
    [self.nextQuestionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //self.answer Configure
    [self creatNewAnswerBtn:question];
    
    //self.optionView Configure
    [self creatNewOptionBtn:question];

}


-(void)newQuestion
{
    self.index ++;
    [self.optionView setUserInteractionEnabled:YES];
    if (self.index >= self.modelArray.count) {
        self.index = 9;
        [self alertViewShow:@"提示" AndMessage:@"已经通关"];
        return;
    }
    model *question = self.modelArray[self.index];
    
    //设置基本信息
    [self setupBasicInfo:question];
    //创建答案按钮
    [self creatNewAnswerBtn:question];
    //创建被选按钮
    [self creatNewOptionBtn:question];
}

//创建答案按钮选项
-(void)creatNewAnswerBtn:(model *)question
{    //创建新的按钮之前，把self.answer里面所有按钮都清除
    for (UIButton *retrieve in self.answerView.subviews) {
        [retrieve removeFromSuperview];
    }
    
    for (int i=0; i<question.answer.length; i++) {
        CGFloat x = (ScreenWidth - selectButtonW * question.answer.length - selectButtonMargin * (question.answer.length - 1))*0.5 + i*(selectButtonW + selectButtonMargin);
        UIButton *btn_answer = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, selectButtonW, selectButtonH)];
        [btn_answer setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn_answer setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [btn_answer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_answer addTarget:self action:@selector(answerOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:btn_answer];
    }
}

//创建被选按钮选项
-(void)creatNewOptionBtn:(model *)question
{
    //创建新的按钮之前，把self.optionView里面所有按钮都清除
    for (UIButton *retrieve in self.optionView.subviews) {
        [retrieve removeFromSuperview];
    }
    CGFloat x = (self.optionView.bounds.size.width - kTotalCol*selectButtonW - selectButtonMargin*(kTotalCol - 1))*0.5;
    CGFloat y = (self.optionView.bounds.size.height - kTotalRow*selectButtonH - selectButtonMargin*(kTotalRow - 1))*0.5;
    for (int i=0; i<question.options.count; i++) {
        int row = i/kTotalCol;
        int col = i%kTotalCol;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + col*(selectButtonW + selectButtonMargin), y + (selectButtonH + selectButtonMargin)*row, selectButtonW, selectButtonH)];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:question.options[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(optionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionView addSubview:btn];
    }
}

//设置基本信息
-(void)setupBasicInfo:(model *)question
{
    self.descriptionLabel.text = question.title;
    [self.bigImage setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",self.index+1,self.modelArray.count];
    self.nextQuestionBtn.enabled = (self.index != self.modelArray.count - 1);
}


//被选答案点击事件
-(void)optionOnClick:(UIButton *)btn
{
    //把被选按钮放在答案按钮里面
    for (UIButton *retrieve in self.answerView.subviews) {
        if (retrieve.currentTitle.length == 0) {
            [retrieve setTitle:btn.currentTitle forState:UIControlStateNormal];
            break;
        }
    }
    btn.hidden = YES;
    
    //先默认答案选项已满
    self.full = YES;
    
    NSMutableString *judgeAnswer = [NSMutableString string];
    for (UIButton *retrieve in self.answerView.subviews) {
        if (retrieve.currentTitle.length == 0) {
            self.full = NO;
            break;
        }
        else
        {
            [judgeAnswer appendString:retrieve.currentTitle];
        }
    }
    
    if (self.isFull) {
        [self.optionView setUserInteractionEnabled:NO];
        model *question = self.modelArray[self.index];
        if ([question.answer isEqualToString:judgeAnswer]) {
            for (UIButton *retrieve in self.answerView.subviews) {
                [retrieve setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            }
            [self performSelector:@selector(newQuestion) withObject:nil afterDelay:0.5];
            [self changeScore:10];
        }
        else
        {
            for (UIButton *retrieve in self.answerView.subviews) {
                [retrieve setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            [self alertViewShow:@"提示" AndMessage:@"答案错误"];
                }
    }
    judgeAnswer = nil;
}


//答案按钮点击事件
-(void)answerOnClick:(UIButton *)btn
{
    //让被选按钮可以触发点击事件
    [self.optionView setUserInteractionEnabled:YES];
    
    if (btn.currentTitle.length == 0) {
        return;
    }
    for (UIButton *retrieve in self.optionView.subviews) {
        if ([retrieve.currentTitle isEqualToString:btn.currentTitle]&&retrieve.isHidden == YES) {
            retrieve.hidden = NO;
            [btn setTitle:nil forState:UIControlStateNormal];
            break;
        }
    }
    for (UIButton *retrieve in self.answerView.subviews) {
        [retrieve setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

//提示按钮
-(void)tipsOnClick
{
    int currentScore = [self.moneyBtn.currentTitle intValue];

    //将答案区所有按钮清空
    if (currentScore != 0) {
        for (UIButton *btn in self.answerView.subviews) {
            [self answerOnClick:btn];
        }
    }
    model *question = self.modelArray[self.index];
    NSString *firstWord = [question.answer substringToIndex:1];
        for (UIButton *retrieve in self.optionView.subviews) {
        if ([retrieve.currentTitle isEqualToString:firstWord]) {
            if (currentScore == 0) {
                [self alertViewShow:@"提示" AndMessage:@"分数用完，不能提示！"];
            }
            else
            {
                [self optionOnClick:retrieve];
                [self changeScore:-10];
                break;
            }
        }
    }
}

//计分数
-(void)changeScore:(int)score
{
    int currentScore = [self.moneyBtn.currentTitle intValue];
    currentScore += score;
    [self.moneyBtn setTitle:[NSString stringWithFormat:@"%d",currentScore] forState:UIControlStateNormal];
}

//遮罩效果
-(void)btn_batOnClick
{
    if (self.btn_bat.alpha == 0.0f) {
        //将图片移动到视图顶层
        [self.view bringSubviewToFront:self.bigImage];
        //动画方法效果
        [UIView animateWithDuration:1.0f animations:^{
            self.bigImage.frame = CGRectMake(0, (ScreenHeight - ScreenWidth)*0.5, ScreenWidth, ScreenWidth);
            self.btn_bat.alpha = 0.5f;
        }];
    }
    else
    {
        [UIView animateWithDuration:1.0f animations:^{
           self.bigImage.frame = CGRectMake(ScreenWidth*0.25, CGRectGetMaxY(self.pageLabel.frame) + controlMargin, ScreenWidth*0.5, ScreenWidth*0.5);
            self.btn_bat.alpha = 0.0f;
        }];
    }
}

//提示框
-(void)alertViewShow:(NSString *)tips AndMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tips message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAciton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //iOS指南规定，取消键在左边
    UIAlertAction *cancleAciton = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAciton];
    [alert addAction:cancleAciton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
