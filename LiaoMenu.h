//
//  LiaoMenu.h
//  廖万军的通讯录
//
//  Created by student on 2019/6/24.
//  Copyright © 2019年 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiaoTeibook.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiaoMenu : NSObject
@property (strong,nonatomic) NSArray *items;
@property (strong,nonatomic) LiaoTeibook *book;
-(void)show;
-(BOOL)input;
@end

NS_ASSUME_NONNULL_END
