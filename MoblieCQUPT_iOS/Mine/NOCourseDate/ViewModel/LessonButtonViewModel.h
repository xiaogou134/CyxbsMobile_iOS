//
//  LessonButtonViewModel.h
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2017/9/26.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LZPersonModel;
@interface LessonButtonViewModel : NSObject
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, copy) NSString *titles;
@property (nonatomic, copy) NSString *color;
- (instancetype)initWithPersons:(NSArray <LZPersonModel *>*)person day:(NSInteger)day andBeginLesson:(NSInteger) beginLesson;
- (void)handleTitlesWithWeek:(NSInteger)week;
@end
