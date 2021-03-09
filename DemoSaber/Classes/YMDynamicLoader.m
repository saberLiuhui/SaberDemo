//
//  YMDynamicLoader.m
//  LaunchDemo
//
//  Created by Liu,Hui(MBBD) on 2020/7/27.
//  Copyright © 2020 Liu,Hui(MBBD). All rights reserved.
//

#import "YMDynamicLoader.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import "YMModuleManager.h"

#ifdef __LP64__
typedef uint64_t YMExportValue;
typedef struct section_64 YMExportSection;
#define YMGetSectByNameFromHeader getsectbynamefromheader_64
#else
typedef uint32_t YMExportValue;
typedef struct section YMExportSection;
#define YMGetSectByNameFromHeader getsectbynamefromheader
#endif

static void YMDynamicLoader_invoke_method(NSString *level) {
    NSArray *funcArray = [[[YMModuleManager sharedManager] modInitFuncPtrArrayStageDic] objectForKey:level];
    for (NSValue *val in funcArray) {
        YMDynamicLoaderInjectFunction func = val.pointerValue;
        func();
    }
}

NSArray<NSValue *>* YMReadSection(char *sectionName, const struct mach_header *mhp);

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    for (NSString *stage in [YMModuleManager sharedManager].stageArray) {
        NSString *fKey = [NSString stringWithFormat:@"__%@%s", stage?:@"", YMDYML_SECTION_SUFFIX];
        NSArray *funcArray = YMReadSection((char *)[fKey UTF8String], mhp);
        [[YMModuleManager sharedManager] addModuleInitFuncs:funcArray forStage:stage];
    }
}

NSArray<NSValue *>* YMReadSection(char *sectionName, const struct mach_header *mhp) {
    NSMutableArray *funcArray = [NSMutableArray array];
    
    const YMExportValue mach_header = (YMExportValue)mhp;
    const YMExportSection *section = YMGetSectByNameFromHeader((void *)mach_header, YMDYML_SEGMENTNAME, sectionName);
    if (section == NULL) return @[];
    
    int addrOffset = sizeof(struct YM_Function);
    for (YMExportValue addr = section->offset;
         addr < section->offset + section->size;
         addr += addrOffset) {
        
        struct YM_Function entry = *(struct YM_Function *)(mach_header + addr);
        [funcArray addObject:[NSValue valueWithPointer:entry.function]];
    }
    
    return funcArray;
}

__attribute__((constructor))
void initYMProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

@implementation YMDynamicLoader

+ (void)executeFunctionsForKey:(NSString *)key {
    YMDynamicLoader_invoke_method(key);
}

@end
