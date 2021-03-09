//
//  YMModuleManager.h
//  LaunchDemo
//
//  Created by Liu,Hui(MBBD) on 2020/7/27.
//  Copyright © 2020 Liu,Hui(MBBD). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMModuleManager : NSObject

+ (instancetype)sharedManager;
- (void)addModuleInitFuncs:(NSArray *)funcArray forStage:(NSString *)stage;

@property (nonatomic, strong) NSArray *stageArray;
@property (nonatomic, strong) NSMutableDictionary *modInitFuncPtrArrayStageDic;

@end

NS_ASSUME_NONNULL_END
