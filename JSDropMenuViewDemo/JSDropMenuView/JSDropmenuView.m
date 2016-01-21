//
//  JSDropmenuView.m
//  ###
//
//  Created by jsfu on 16/1/19.
//  Copyright © 2016年 jsfu. All rights reserved.
//

#define MenuBackgroundColor [UIColor colorWithRed:75/255.0 green:82/255.0 blue:89/255.0 alpha:1.0]
#define MenuLineColor [UIColor colorWithRed:95/255.0 green:100/255.0 blue:104/255.0 alpha:1.0]

#import "JSDropmenuView.h"

@interface JSDropmenuViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *icoImageView;

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UIView *lineView;
@end

@implementation JSDropmenuViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.icoImageView = ({
        UIImageView *icoImageView = [[UIImageView alloc] init];
        icoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:icoImageView];
        
        icoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * l_c = [NSLayoutConstraint constraintWithItem:icoImageView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:10*Screen320Scale];
        
        NSLayoutConstraint * c_c = [NSLayoutConstraint constraintWithItem:icoImageView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0];
        
        NSLayoutConstraint * w_c = [NSLayoutConstraint constraintWithItem:icoImageView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:18*Screen320Scale];
        
        NSLayoutConstraint * h_c = [NSLayoutConstraint constraintWithItem:icoImageView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:18*Screen320Scale];
        
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [NSLayoutConstraint activateConstraints:@[l_c, c_c, w_c, h_c]];
        } else {
            [self.contentView addConstraints:@[l_c, c_c]];
            [icoImageView addConstraints:@[w_c, h_c]];
        }
        
        icoImageView;
    });
    
    self.titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14*Screen320Scale];
        titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:titleLabel];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint * l_c = [NSLayoutConstraint constraintWithItem:titleLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.icoImageView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0
                                                                 constant:15];
        
        NSLayoutConstraint * c_c = [NSLayoutConstraint constraintWithItem:titleLabel
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [NSLayoutConstraint activateConstraints:@[l_c, c_c]];
        } else {
            [self.contentView addConstraints:@[l_c, c_c]];
        }
        
        titleLabel;
    });
    
    self.lineView = ({
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = MenuLineColor;
        [self.contentView addSubview:lineView];

        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *b_c = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        NSLayoutConstraint *l_c = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        NSLayoutConstraint *r_c = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        NSLayoutConstraint *h_c = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [NSLayoutConstraint activateConstraints:@[b_c, l_c, r_c, h_c]];
        } else {
            [self.contentView addConstraints:@[b_c, l_c, r_c]];
            [lineView addConstraints:@[h_c]];
        }
        
        lineView;
    });
}

@end


@interface JSDropmenuView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UIView *touchView;
@property(nonatomic,strong) UIView *showContainerView;
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic) CGRect showContainerViewFrame;
@end

@implementation JSDropmenuView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.showContainerViewFrame = frame;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.touchView = ({
        UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:touchView];
        touchView;
    });
    
    self.showContainerView = ({
        UIView *showContainerView = [[UIView alloc] initWithFrame:self.showContainerViewFrame];
        showContainerView.layer.masksToBounds = YES;
        [self addSubview:showContainerView];
        showContainerView;
    });
    
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 10)];
    [path addLineToPoint:CGPointMake(6, 0)];
    [path addLineToPoint:CGPointMake(12, 10)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = MenuBackgroundColor.CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = CGPointMake(self.showContainerView.frame.size.width-20, 10);
    [self.showContainerView.layer addSublayer:layer];
    
    self.mainTableView = ({
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 12, self.showContainerView.frame.size.width, self.showContainerView.frame.size.height-12)];
        mainTableView.backgroundColor = MenuBackgroundColor;
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView.backgroundColor = [UIColor clearColor];
        mainTableView.layer.cornerRadius = 3;
        mainTableView.layer.masksToBounds = YES;
        [self.showContainerView addSubview:mainTableView];
        mainTableView;
    });
    
    UIGestureRecognizer *tapBgViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [self.touchView addGestureRecognizer:tapBgViewGesture];

}

#pragma - mark UITableViewDelegate UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropmenuDataSource)]) {
        return [[self.delegate dropmenuDataSource] count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38*Screen320Scale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *optionIdentifier = @"DropMenuTableViewCell";
    JSDropmenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:optionIdentifier];
    if (!cell) {
        cell = [[JSDropmenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:optionIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MenuBackgroundColor;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropmenuDataSource)]) {
        NSDictionary *itemDic = [[self.delegate dropmenuDataSource] objectAtIndex:indexPath.row];
        cell.icoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [itemDic objectForKey:@"imageName"]]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", [itemDic objectForKey:@"title"]];
        
        if (indexPath.row == [[self.delegate dropmenuDataSource] count]-1) {
            cell.lineView.hidden = YES;
        } else {
            cell.lineView.hidden = NO;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropmenuView:didSelectedRow:)]) {
        [self.delegate dropmenuView:self didSelectedRow:indexPath.row];
        [self hideView:^{
            
        }];
    }
}

#pragma mark - property

#pragma mark - action
- (void)showViewInView:(UIView*)view {
    
    [view addSubview:self];
    [self setAnchorPoint:CGPointMake(0.9, 0) forView:self.showContainerView];
    self.showContainerView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showContainerView.transform = CGAffineTransformMakeScale(0.99, 0.99);
    } completion:^(BOOL finished) {
        [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self.showContainerView];
        self.showContainerView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)closeView:(id)sender {
    [self hideView:^{
        
    }];
}

- (void)hideView:(void (^)(void))block{
    
    [self setAnchorPoint:CGPointMake(0.9, 0) forView:self.showContainerView];
    [UIView animateWithDuration:0.3 animations:^{
        self.showContainerView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    } completion:^(BOOL finished) {
        [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self.showContainerView];
        [self removeFromSuperview];
        block();
    }];
}

@end
