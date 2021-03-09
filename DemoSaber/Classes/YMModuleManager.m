//
//  YMModuleManager.m
//  LaunchDemo
//
//  Created by Liu,Hui(MBBD) on 2020/7/27.
//  Copyright © 2020 Liu,Hui(MBBD). All rights reserved.
//

#import "YMModuleManager.h"

@implementation YMModuleManager

+ (instancetype)sharedManager {
    static YMModuleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YMModuleManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stageArray = @[
                            @"STAGE_A",
                            @"STAGE_B",
                            @"STAGE_C",
                            @"STAGE_D"
                            ];
        self.modInitFuncPtrArrayStageDic = [NSMutableDictionary dictionary];
        for (NSString *stage in self.stageArray) {
            self.modInitFuncPtrArrayStageDic[stage] = [NSMutableArray array];
        }
    }
    return self;
}

- (void)addModuleInitFuncs:(NSArray *)funcArray forStage:(NSString *)stage {
    NSMutableArray *stageArray = self.modInitFuncPtrArrayStageDic[stage];
    [stageArray addObjectsFromArray:funcArray];
}

@end
