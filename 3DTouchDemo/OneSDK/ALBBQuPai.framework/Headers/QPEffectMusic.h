//
//  QPEffectMusic.h
//  QupaiSDK
//
//  Created by yly on 15/6/18.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "QPEffect.h"

@interface QPEffectMusic : QPEffect

@property (nonatomic, strong) NSString *musicName;

- (BOOL)isEmptyMusic;

@end
