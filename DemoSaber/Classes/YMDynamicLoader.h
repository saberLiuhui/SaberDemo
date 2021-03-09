//
//  YMDynamicLoader.h
//  LaunchDemo
//
//  Created by Liu,Hui(MBBD) on 2020/7/27.
//  Copyright © 2020 Liu,Hui(MBBD). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (*YMDynamicLoaderInjectFunction)(void);

#define YMDYML_SEGMENTNAME      "__DATA"
#define YMDYML_SECTION_SUFFIX   "ym_func"

#pragma mark - 实现存储函数


struct YM_Function {
    char *key;
    void (*function)(void);
};

//__attribute__((used, section("__DATA" "," "__kylin__"))) static const KLN_DATA __kylin__0 = (KLN_DATA){(KLN_DATA_HEADER){"Key", KLN_STRING, KLN_IS_ARRAY}, "Value"};

// static void _ymSTAGE_C(void);
// __attribute__((used, section("__DATA" ",__""STAGE_C" "ym_func")))
// static const struct YM_Function __FSTAGE_C = (struct YM_Function){(char *)(&"STAGE_C"), (void *)(&_ymSTAGE_C)};
#define YM_FUNCTION_EXPORT(key) \
static void _ym##key(void); \
__attribute__((used, section(YMDYML_SEGMENTNAME ",__"#key YMDYML_SECTION_SUFFIX))) \
static const struct YM_Function __F##key = (struct YM_Function){(char *)(&#key), (void *)(&_ym##key)}; \
static void _ym##key \

@interface YMDynamicLoader : NSObject

+ (void)executeFunctionsForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
