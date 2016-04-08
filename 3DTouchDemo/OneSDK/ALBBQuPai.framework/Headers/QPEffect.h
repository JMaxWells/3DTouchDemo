//
//  QPEffect.h
//  QupaiSDK
//
//  Created by yly on 15/6/18.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    QPEffectTypeFilter,
    QPEffectTypeMusic,
    QPEffectTypeMV,
}QPEffectType;

@interface QPEffect : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) QPEffectType type;
@property (nonatomic, assign) NSInteger eid;

- (BOOL)isMore;
- (BOOL)isEmpty;

@end
