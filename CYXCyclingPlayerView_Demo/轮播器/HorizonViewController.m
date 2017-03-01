//
//  ViewController.m
//  轮播器
//
//  Created by 薛权 on 17/1/10.
//  Copyright © 2017年 薛权. All rights reserved.
//

#import "HorizonViewController.h"
#import "CYXCyclingPlayerView.h"
#import "CYXCyclingPictureCell.h"
#import "CYXCyclingBrandCell.h"

@interface HorizonViewController ()<CYXCyclingPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet CYXCyclingPlayerView *cyclingPlayerView;
@property (weak, nonatomic) IBOutlet CYXCyclingPlayerView *cyclingBrandView;
@property (weak, nonatomic) IBOutlet UILabel *position;

@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, assign) NSInteger posNum;

@property (nonatomic, strong) NSMutableArray *multiCyclingImgs;

@end

@implementation HorizonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imgs = [NSMutableArray arrayWithObjects:@"xq_1", @"xq_2", @"xq_3", @"xq_4", @"xq_5", @"xq_6", nil];
    self.imgs = [NSMutableArray arrayWithObjects:@"xq_1", @"xq_2", @"xq_3", @"xq_4", nil];
    self.multiCyclingImgs = [NSMutableArray arrayWithObjects:@"xq_s0", @"xq_s1", @"xq_s2", @"xq_s3", nil];
//    self.multiCyclingImgs = [NSMutableArray arrayWithObjects:@"xq_s0", @"xq_s1", @"xq_s2", @"xq_s3", @"xq_s4", @"xq_s5", nil];
    self.position.text = [NSString stringWithFormat:@"当前滚动到第0页"];
    
    self.cyclingPlayerView.infiniteLoop = NO;
    self.cyclingPlayerView.autoScroll = NO;
    self.cyclingPlayerView.autoScrollTimeInterval = 1.0f;
    self.cyclingPlayerView.pageControlPosition = (CYXPageControlPosition)self.posNum;
    self.cyclingPlayerView.delegate = self;
    [self.cyclingPlayerView registerNib:[UINib nibWithNibName:NSStringFromClass([CYXCyclingPictureCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CYXCyclingPictureCell class])];
    
    self.cyclingBrandView.pagingEnabled = NO;
    self.cyclingBrandView.showPageControl = NO;
    self.cyclingBrandView.autoScroll = NO;
    self.cyclingBrandView.autoScrollTimeInterval = 1.0f;
    self.cyclingBrandView.infiniteLoop = NO;
    self.cyclingBrandView.itemsPerPage = 3;
    self.cyclingBrandView.pageControlPosition = (CYXPageControlPosition)self.posNum;
    self.cyclingBrandView.delegate = self;
    [self.cyclingBrandView registerClass:[CYXCyclingBrandCell class] forCellWithReuseIdentifier:NSStringFromClass([CYXCyclingBrandCell class])];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"刷新";
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.navigationItem.rightBarButtonItem.title = @"刷新";
    
    if (self.imgs.count == 6) {
        self.imgs = [NSMutableArray arrayWithObjects:@"xq_1", @"xq_2", @"xq_3", @"xq_4", nil];
    } else {
        self.imgs = [NSMutableArray arrayWithObjects:@"xq_1", @"xq_2", @"xq_3", @"xq_4", @"xq_5", @"xq_6", nil];
    }
    
    [self.cyclingPlayerView reloadData];
    NSLog(@"dsfdsf");
}

- (IBAction)addNum:(id)sender {
    self.posNum++;
    if (self.posNum >= 5) {
        self.posNum = 5;
    }
    self.cyclingPlayerView.pageControlPosition = (CYXPageControlPosition)self.posNum;
}

- (IBAction)minusNum:(id)sender {
    self.posNum--;
    if (self.posNum <= 0) {
        self.posNum = 0;
    }
    self.cyclingPlayerView.pageControlPosition = (CYXPageControlPosition)self.posNum;
}

- (IBAction)startScroll:(UIButton *)sender {
    self.cyclingPlayerView.autoScroll = !self.cyclingPlayerView.autoScroll;
    
    if (self.cyclingPlayerView.autoScroll) {
        [sender setTitle:@"关自动滚动" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"开自动滚动" forState:UIControlStateNormal];
    }
}

- (IBAction)startStyleTwo:(UIButton *)sender {
    
    self.cyclingBrandView.autoScroll = !self.cyclingBrandView.autoScroll;
    
    if (self.cyclingBrandView.autoScroll) {
        [sender setTitle:@"关自动滚动" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"开自动滚动" forState:UIControlStateNormal];
    }
}

- (IBAction)openCycling:(UIButton *)sender {
    self.cyclingPlayerView.infiniteLoop = !self.cyclingPlayerView.infiniteLoop;
    
    if (self.cyclingPlayerView.infiniteLoop) {
        [sender setTitle:@"关无限循环" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"开无限循环" forState:UIControlStateNormal];
    }
}

- (IBAction)openCyclingStyleTwo:(UIButton *)sender {
    self.cyclingBrandView.infiniteLoop = !self.cyclingBrandView.infiniteLoop;
    
    if (self.cyclingBrandView.infiniteLoop) {
        [sender setTitle:@"关无限循环" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"开无限循环" forState:UIControlStateNormal];
    }
}

- (NSInteger)numberOfItemsInCyclingView:(CYXCyclingPlayerView *)cyclingView
{
    if (cyclingView == self.cyclingPlayerView) {
        return self.imgs.count;
    } else {
        return self.multiCyclingImgs.count;
    }
}

- (UICollectionViewCell *)cyclingView:(CYXCyclingPlayerView *)cyclingView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cyclingView == self.cyclingPlayerView) {
        CYXCyclingPictureCell *cell = (CYXCyclingPictureCell *)[cyclingView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYXCyclingPictureCell class]) forIndexPath:indexPath];
        NSString *pictureName = [self.imgs objectAtIndex:indexPath.row];
        [cell.userIntroImageView setImage:[UIImage imageNamed:pictureName]];
        
        return cell;
    } else {
        CYXCyclingBrandCell *cell = (CYXCyclingBrandCell *)[cyclingView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYXCyclingBrandCell class]) forIndexPath:indexPath];
        NSString *pictureName = [self.multiCyclingImgs objectAtIndex:indexPath.row];
        cell.brandLogo.image = [UIImage imageNamed:pictureName];
        cell.brandName.text = [NSString stringWithFormat:@"第%ld个", indexPath.row];
        return cell;
    }
}

- (void)cyclingView:(CYXCyclingPlayerView *)cyclingView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的是第%ld个", (long)indexPath.row);
    NSString *tip = [NSString stringWithFormat:@"点击的是第%ld个", (long)indexPath.row];
    self.position.text = tip;
}

- (void)cyclingView:(CYXCyclingPlayerView *)cyclingView didScrollToIndex:(NSInteger)index
{
    if (cyclingView == self.cyclingPlayerView) {
        NSString *tip = [NSString stringWithFormat:@"当前滚动到第%ld页", (long)index];
        self.position.text = tip;
    }
}


@end
