//
//  JSDropmenuView.h
//  ###
//
//  Created by jsfu on 16/1/19.
//  Copyright © 2016年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define Screen320Scale SCREEN_WIDTH/320.0f

@class JSDropmenuView;
@protocol  JSDropmenuViewDelegate<NSObject>

/**
 *  选择行回调
 *
 *  @param dropmenuView
 *  @param index        选中行
 */
- (void)dropmenuView:(JSDropmenuView*)dropmenuView didSelectedRow:(NSInteger)index;

@optional
/**
 *  下拉菜单数据源
 *
 *  @return
 */
- (NSArray*)dropmenuDataSource;

@end

@interface JSDropmenuView : UIView

@property(nonatomic,strong) id<JSDropmenuViewDelegate> delegate;

- (void)showViewInView:(UIView*)view;

- (void)hideView:(void(^)(void))block;

@end
