//
//  VerticalPlayerViewController.m
//  轮播器
//
//  Created by 薛权 on 17/2/4.
//  Copyright © 2017年 薛权. All rights reserved.
//

#import "VerticalPlayerViewController.h"
#import "CYXCyclingPlayerView.h"

@interface VerticalPlayerViewController ()<CYXCyclingPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet CYXCyclingPlayerView *cyclingView;

@end

@implementation VerticalPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cyclingView.infiniteLoop = YES;
    self.cyclingView.autoScroll = YES;
    self.cyclingView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cyclingView.autoScrollTimeInterval = 1.0f;
    self.cyclingView.delegate = self;
    [self.cyclingView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    NSLog(@"%@", self.cyclingView);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (NSInteger)numberOfItemsInCyclingView:(CYXCyclingPlayerView *)cyclingView
{
    return 3;
}

- (UICollectionViewCell *)cyclingView:(CYXCyclingPlayerView *)cyclingView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cyclingView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UILabel *textLabel = [cell.contentView viewWithTag:10000];
    if (textLabel == nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        textLabel.backgroundColor = [UIColor cyanColor];
        [cell.contentView addSubview:textLabel];
    }
    textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}


@end
