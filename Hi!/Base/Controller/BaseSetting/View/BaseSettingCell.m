//
//  BaseSettingCell.m
//  易商
//
//  Created by namebryant on 14-10-6.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseSettingCell.h"

@interface BaseSettingCell()



@end

@implementation BaseSettingCell
#pragma mark -UITextField-NSNotificationCenter
-(void)userDidChange:(NSNotification*)notifation{
    
    if(self.item.baseSettingItemTextDidChangeOption){
        self.item.baseSettingItemTextDidChangeOption(self.inputTextField);
    }
    
}

- (void)switchChange
{
    // 存储数据
    if (self.item.option) {
        self.item.option(@(!self.item.on));
    }
}


- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _arrowView;
}

- (UIImageView *)checkView
{
    if (_checkView == nil) {
        _checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_checkmark"]];
        _checkView.hidden=!self.item.isChecked;

    }
    return _checkView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        _switchView.on=self.item.isOn;
        [_switchView addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    BaseSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BaseSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
       
        //输入框
        
        [self.contentView addSubview:self.inputTextField];
        
        //子标题
        [self.contentView addSubview:self.subtitleLabel];
        
        // 标题
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        
        // 最右边的详情文字
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        
        UIImageView *bg = [[UIImageView alloc] init];
        self.backgroundView = bg;
        self.bg = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        self.selectedBackgroundView = selectedBg;
        self.selectedBg = selectedBg;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -TextLabel
#pragma mark - InputTextField
-(UITextField *)inputTextField{

    if (!_inputTextField) {
        _inputTextField=[[UITextField alloc] init];
        _inputTextField.backgroundColor=[UIColor whiteColor];
        _inputTextField.textColor = [UIColor grayColor]; //text color
        _inputTextField.font = [UIFont systemFontOfSize:16.0];  //font size
        _inputTextField.clearButtonMode=UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDidChange:) name:UITextFieldTextDidChangeNotification object:_inputTextField];
        
    }
    
    return _inputTextField;
    
}
#pragma mark - SubtitleLabel
-(UILabel *)subtitleLabel{

    if (!_subtitleLabel) {
        // 子标题
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.numberOfLines=0;
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.textColor = [UIColor blackColor];
        subtitleLabel.highlightedTextColor = subtitleLabel.textColor;
        subtitleLabel.font = [UIFont systemFontOfSize:15];
        
        self.subtitleLabel = subtitleLabel;
    }
    
    return _subtitleLabel;
    
}


- (void)setItem:(BaseSettingItem *)item
{
    _item = item;
    // 2.设置右边的控件
    self.textLabel.text = self.item.title;
    if (item.icon) {
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    [self setupRightView];
}


- (CGSize)heightForTitleLabel:(NSString*)subTitle
{
    UIFont *font=[UIFont systemFontOfSize:15];
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [subTitle boundingRectWithSize:CGSizeMake(200,font.lineHeight * 5) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attribute context:NULL].size;

    return size;
}
#pragma mark -得到数据布局
- (void)layoutSubviews
{
    [super layoutSubviews];
   
    //设置图片
    [self setImageViewAfterHaveData:self.item];
    
    // 设置textField
    [self setTextTitleAfterHaveData:self.item];
    
    //设置 SubTitle
    [self setSubtitleLabelAfterHaveData:self.item];

    //设置inputTextField
    [self setInputTextFieldAfterHaveData:self.item];
    
    if (self.item.avatorImage) {
        self.avatarImageView.image=self.item.avatorImage;
    }
}

#pragma mark -设置图片
-(void)setImageViewAfterHaveData:(BaseSettingItem*)item{
    // 1.图标
  
}

#pragma mark -设置 inputTextField
-(void)setInputTextFieldAfterHaveData:(BaseSettingItem*)item{

    //4.输入框
    if (self.item.settingItemSytle==BaseSettingItemSytleTextField) {
        self.inputTextField.frame=CGRectMake(50,5, self.frame.size.width-50, 40);
        self.inputTextField.placeholder=item.placeholder;
        self.inputTextField.keyboardType=item.keyBoardType;
        self.inputTextField.SecureTextEntry=item.isSecure;
        self.inputTextField.hidden=NO;
        self.subtitleLabel.hidden = YES;
        if (self.item.isFirstResponser) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.inputTextField becomeFirstResponder];
            });
        }else{
            [self.inputTextField resignFirstResponder];
        }
        
    }else{
        self.inputTextField.hidden=YES;
    }
}
#pragma mark -设置 TextTitle
-(void)setTextTitleAfterHaveData:(BaseSettingItem*)item{
    
    
    CGSize size = self.bounds.size;
    CGRect frame = CGRectMake(10.0f, 13.0f, size.width, 20);
    self.textLabel.frame =  frame;
    self.textLabel.contentMode = UIViewContentModeScaleAspectFit;
    if (item.settingItemInfo){
        if (item.settingItemInfo[BaseSettingItemTitleFont]) {
            self.textLabel.font=item.settingItemInfo[BaseSettingItemTitleFont];
        }
        if (item.settingItemInfo[BaseSettingItemTitleColor]) {
            self.textLabel.textColor=item.settingItemInfo[BaseSettingItemTitleColor];
        }
    }

}

#pragma mark -设置 Subtitle
-(void)setSubtitleLabelAfterHaveData:(BaseSettingItem*)item{
    
    
    // 3.子标题
    if (self.item.subtitle) {
        self.subtitleLabel.hidden = NO;
        [self.subtitleLabel sizeToFit];
        self.subtitleLabel.text = self.item.subtitle;
    } else {
        self.subtitleLabel.hidden = YES;
    }
    
    // 设置子标题,跟对应属性
    
    if (!item.title&&!item.icon) {
        self.subtitleLabel.frame=self.bounds;
        self.subtitleLabel.textAlignment=NSTextAlignmentCenter;
    }else if(!item.title&&item.icon){
        self.subtitleLabel.frame = CGRectMake(50, 15, [self heightForTitleLabel:item.subtitle].width, [self heightForTitleLabel:item.subtitle].height);

    }else{
        self.subtitleLabel.frame = CGRectMake(60, 15, [self heightForTitleLabel:item.subtitle].width, [self heightForTitleLabel:item.subtitle].height);
    }
    if (item.settingItemInfo){
        if (item.settingItemInfo[BaseSettingItemSubTitleFont]) {
            self.subtitleLabel.font=item.settingItemInfo[BaseSettingItemSubTitleFont];
        }
        if (item.settingItemInfo[BaseSettingItemSubTitleColor]) {
            self.subtitleLabel.textColor=item.settingItemInfo[BaseSettingItemSubTitleColor];
        }
    }
    self.item.subtitleSize=[self heightForTitleLabel:item.subtitle];
}

/**
 *  设置右边的控件
 */
- (void)setupRightView
{
    if (self.item.badgeValue)
    { // 右边显示数字
//        self.badgeButton.badgeValue = self.item.badgeValue;
//        self.accessoryView = self.badgeButton;
    }
    else if (self.item.settingItemSytle==BaseSettingItemSytleLabel)
    { // 右边是文字
        self.accessoryView = nil;
    }
    else if (self.item.settingItemSytle==BaseSettingItemSytleSwitch)
    { // 右边是开关
        self.accessoryView = self.switchView;
    }
    else if (self.item.settingItemSytle==BaseSettingItemSytleArrow)
    { // 右边是箭头
        self.accessoryView = self.arrowView;
    }
    else if (self.item.settingItemSytle==BaseSettingItemSytleCheck)
    { // 右边是打钩
        self.accessoryView = self.item.isChecked ? self.checkView : nil;
    }else if (self.item.settingItemSytle==BaseSettingItemSytleAvator){
    
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        imgView.contentMode=UIViewContentModeScaleAspectFill;
        imgView.layer.cornerRadius=imgView.width/2;
        imgView.clipsToBounds=YES;
        imgView.image=self.item.avatorImage;
        self.accessoryView =imgView;
    }
    else { // 右边没有东西
        self.accessoryView = nil;
    }
}
#pragma mark -设置背景
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    NSString *selectedBgName = nil;
    selectedBgName = @"common_card_middle_background_highlighted_os7";
    self.bg.image = [UIImage resizedImage:@"common_card_middle_background_os7"];;
    self.selectedBg.image = [UIImage resizedImage:selectedBgName];

   
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
