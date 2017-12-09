//
//  PlateViewController.m
//  机修业
//  车牌输入类
//  Created by 途铂软件 on 2017/12/9.
//  Copyright © 2017年 途铂软件. All rights reserved.
//

#import "PlateViewController.h"
#import "DOPDropDownMenu.h"
#import "ProvinceCollectionViewCell.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MyRGB16Color(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//主色调
#define kMainTextColor MyRGB16Color(0x474747)

#define kMainColor MyRGB16Color(0xe83921)
#define kMainBgColor MyRGB16Color(0xEAF3F3)

@interface PlateViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {

    NSInteger  index;
    NSInteger  carSelectIndex;
    

    NSMutableArray *_carList;
    NSMutableArray *_provinceArray;
    
    NSMutableArray *_numberLetterArray;
    
    Boolean isProvince;
    UICollectionView  * inputView;
    
    UITextField *_currentTF;
}

@property (nonatomic, strong) NSArray *carType;
@property (nonatomic, strong) UIView *plateView;
@property (nonatomic, strong) NSArray *plateArray;

@end

@implementation PlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    index=0;
    [self initData];
    [self initKeyView];
    
    [self setNavigator];
    [self showDownMenu];
    [self addPlateNumberVie];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigator{
    self.title = @"车牌选择";
}

// 添加车牌类型选择
-(void)showDownMenu {
    
    self.carType = @[@"小型汽车（蓝牌）",@"大型货车（黄牌）"];
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64 + 40) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    menu.backgroundColor = [UIColor brownColor];
    [self.view addSubview:menu];
    
    //当下拉菜单收回时的回调，用于网络请求新的数据
    menu.finishedBlock=^(DOPIndexPath *indexPath){
        if (indexPath.item >= 0) {
            NSLog(@"收起:点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        }else {
            NSLog(@"收起:点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
            if (indexPath.row == 0) {
                _plateView.backgroundColor = [UIColor blueColor];
            } else {
                _plateView.backgroundColor = [UIColor yellowColor];
            }
        }
    };
}
// 添加车牌输入视图
-(void)addPlateNumberVie {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.plateArray = @[@"宁",@"A",@"·",@"",@"",@"",@"",@""];

    self.plateView = [[UIView alloc] initWithFrame:CGRectMake(10, 164, width - 20, 60)];
    self.plateView.backgroundColor = [UIColor blueColor];
    self.plateView.layer.cornerRadius = 8;
    [self.view addSubview:self.plateView];
    CGFloat tWidth = (CGRectGetMaxX(self.plateView.frame) - 8*8)/8;
    for (int i = 0; i < self.plateArray.count; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(8*(i+1) + i*tWidth, 10, tWidth, 40)];
        textField.tintColor= [UIColor clearColor];
        textField.inputView=inputView;
        textField.tag = 100 + i;
        textField.backgroundColor = [UIColor whiteColor];
        textField.text = self.plateArray[i];
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setAdjustsFontSizeToFitWidth:YES];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField setDelegate:self];
        [textField.layer setMasksToBounds:YES];
        [textField.layer setCornerRadius:8.0];//设置矩形四个圆角半径
        [textField.layer setBorderWidth:1.5];//边框宽度
        [textField.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        if (i == 2) {
            textField.frame = CGRectMake(8*i + i*tWidth, 10, tWidth, 40);
            textField.backgroundColor = [UIColor clearColor];
            [textField.layer setBorderWidth:0];//边框宽度
        } else if (i >= 3) {
            textField.frame = CGRectMake(8*(i-1) + i*tWidth, 10, tWidth, 40);
        }
        
        [self.plateView addSubview:textField];
    }
}

-(void)initData{
    _provinceArray=[NSMutableArray array];
    
    NSArray *arr1 = @[@"京", @"津",@"翼",@"鲁",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪"];
    
    NSArray *arr2 = @[@"苏", @"浙",@"皖",@"闽",@"赣",@"豫",@"鄂",@"湘",@"粤",@"桂"];
    NSArray *arr3 = @[@"渝", @"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青"];
    
    NSArray *arr4 = @[@"隐藏",@"琼", @"新",@"宁",@"港",@"澳",@"台",@"删除"];
    
    [_provinceArray addObject:arr1];
    [_provinceArray addObject:arr2];
    [_provinceArray addObject:arr3];
    [_provinceArray addObject:arr4];
    
    
    _numberLetterArray=[NSMutableArray array];
    NSArray *LetterArray1 = @[@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *LetterArray2 = @[@"Q", @"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P"];
    NSArray *LetterArray3 = @[@"A", @"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L"];
    NSArray *LetterArray4 = @[@"隐藏",@"Z", @"X",@"C",@"V",@"B",@"N",@"M",@"删除"];
    
    [_numberLetterArray addObject:LetterArray1];
    [_numberLetterArray addObject:LetterArray2];
    [_numberLetterArray addObject:LetterArray3];
    [_numberLetterArray addObject:LetterArray4];
}
-(void)initKeyView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    inputView  =[[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenHeight*0.7, ScreenWidth, ScreenHeight*0.3)collectionViewLayout:layout ];
    inputView.delegate=self;
    inputView.dataSource=self;
    inputView.backgroundColor=[UIColor whiteColor];
    [inputView registerNib:[UINib nibWithNibName:@"ProvinceCollectionViewCell"
                                          bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"ProvinceCollectionViewCell"];
}

- (NSInteger)forinArr:(NSInteger )j array:(NSArray *)_arr{
    NSInteger k = 0;
    BOOL isChang = NO;
    for (NSInteger i = j; i < _arr.count; i++) {
        if([_arr[i] text].length == 0)
        {
            k = i;
            [_arr[i] becomeFirstResponder];
            NSLog(@"%lu",k);
            isChang = YES;
            break;
        };
    }
    if (!isChang) {
        for (NSInteger i = 0; i < _arr.count; i++) {
            if([_arr[i] text].length == 0)
            {
                k = i;
                [_arr[i] becomeFirstResponder];
                NSLog(@"%lu",[_arr[i] text].length);
                isChang = YES;
                break;
            };
        }
    }
    NSLog(@"%ld",(long)k);
    if (!isChang) {
        [self.view endEditing:YES];
        return 6;
    }else
        return k;
}



#pragma mark ---textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    index = textField.tag - 100;
    NSLog(@"textField  index%ld",index);
//    textField.text = @"";
    _currentTF = textField;
    
    [textField.layer setBorderColor:[kMainColor CGColor]];
    
    if (index==0) {
        isProvince=YES;
        [inputView reloadData];
        
    }
    else{
        isProvince=NO;
        [inputView reloadData];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma 下拉视图协议方法
/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    return 0;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.carType.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.carType[indexPath.row];
}

#pragma 键盘视图协议
#pragma  mark UICollectionView delegate 方法

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    NSInteger count= _provinceArray.count;
    NSArray *a;
    if(isProvince){
        a =(NSArray *)_provinceArray[section];
    }
    else{
        a =(NSArray *)_numberLetterArray[section];
    }
    
    
    return a.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(isProvince){
        return _provinceArray.count;
    }
    else{
        return  _numberLetterArray.count;
        
    }
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ProvinceCollectionViewCell";
    
    ProvinceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (isProvince) {
        cell.label.text=_provinceArray[indexPath.section][indexPath.row];
    }
    else{
        cell.label.text=_numberLetterArray[indexPath.section][indexPath.row];
    }
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (isProvince) {
        NSArray *a=(NSArray *)_provinceArray[indexPath.section];
        if (indexPath.section==_provinceArray.count-1&&indexPath.row==0) {
            return CGSizeMake((collectionView.frame.size.width/10-6)*2, collectionView.frame.size.height/4-6);
        }
        
        
        if (indexPath.section==_provinceArray.count-1&&indexPath.row==a.count-1) {
            return CGSizeMake((collectionView.frame.size.width/10-6)*2, collectionView.frame.size.height/4-6);
        }
        
    }
    
    else{
        NSArray *a2=(NSArray *)_numberLetterArray[indexPath.section];
        if (indexPath.section==_numberLetterArray.count-1&&indexPath.row==0) {
            return CGSizeMake((collectionView.frame.size.width/10-6)*2, collectionView.frame.size.height/4-6);
        }
        
        
        if (indexPath.section==_numberLetterArray.count-1&&indexPath.row==a2.count-1) {
            return CGSizeMake((collectionView.frame.size.width/10-6)*2, collectionView.frame.size.height/4-6);
        }
        
        
    }
    
    
    
    return CGSizeMake(collectionView.frame.size.width/10-6, collectionView.frame.size.height/4-6);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 3;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 3;}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (section==3) {
        
        if (isProvince) {
            float leftRrightMargin=  (collectionView.frame.size.width-    (collectionView.frame.size.width/10-6)*10)-4*7;
            
            return UIEdgeInsetsMake(3,leftRrightMargin/2 , 3,leftRrightMargin/2);
        }
        else{
            float leftRrightMargin=  (collectionView.frame.size.width-    (collectionView.frame.size.width/10-6)*11)-4*8;
            
            return UIEdgeInsetsMake(3,leftRrightMargin/2 ,3,leftRrightMargin/2);
        }
        
        
    }
    if (section==2) {
        
        if (isProvince) {
            float leftRrightMargin=  (collectionView.frame.size.width-    ( collectionView.frame.size.width/10-6)*8)-4*7;
            return UIEdgeInsetsMake(3,leftRrightMargin/2 , 3,leftRrightMargin/2);
            
        }
        else{
            float leftRrightMargin=  (collectionView.frame.size.width-    ( collectionView.frame.size.width/10-6)*9)-4*8;
            return UIEdgeInsetsMake(3,leftRrightMargin/2 , 3,leftRrightMargin/2);
        }
        
    }
    return UIEdgeInsetsMake(3,15 ,3,15);
}


#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isProvince) {
        NSString * result=_provinceArray[indexPath.section][indexPath.row];
    
        if (indexPath.section==3&&indexPath.row==0) {
            //隐藏
            [self.view endEditing:YES];
        }
        else if (indexPath.section==3&&indexPath.row==7) {
            //删除
            _currentTF.text=@"";
            [_currentTF resignFirstResponder];
            
            if (index>0) {
                UITextField *nextTF = [self.view viewWithTag:index+99];
                [nextTF becomeFirstResponder];
            }
        }
        
        else{
            _currentTF.text = result;
            [_currentTF resignFirstResponder];
            
            if (index<7) {
                UITextField *nextTF = [self.view viewWithTag:index+101];
                [nextTF becomeFirstResponder];
            }
        }
    }
    
    else{
        
        NSString *result=_numberLetterArray[indexPath.section][indexPath.row];
        if (indexPath.section==3&&indexPath.row==0) {
            //隐藏
            [self.view endEditing:YES];
        }
        else if (indexPath.section==3&&indexPath.row==8) {
            //删除
            _currentTF.text = @"";
            if (index > 0) {
                if (index == 3) {
                    index--;
                }
                UITextField *nextTF = [self.view viewWithTag:index+99];
                [nextTF becomeFirstResponder];
            }
        }
        
        else{
            _currentTF.text = result;
            [_currentTF resignFirstResponder];
            if (index<7) {
                if (index == 1) {
                    index++;
                }
                UITextField *nextTF = [self.view viewWithTag:index+101];
                [nextTF becomeFirstResponder];
            }
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
