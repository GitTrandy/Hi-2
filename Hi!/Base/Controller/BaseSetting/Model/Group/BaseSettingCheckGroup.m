//
//  BaseSettingCheckGroup.m
//  易商
//
//  Created by namebryant on 14-10-6.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseSettingCheckGroup.h"
#import "BaseSettingItem.h"
@implementation BaseSettingCheckGroup

- (BaseSettingItem *)checkedItem
{
    for (BaseSettingItem *item in self.items) {
        if (item.isChecked) return item;
    }
    return nil;
}

- (void)setCheckedItem:(BaseSettingItem *)checkedItem
{
    for (BaseSettingItem *item in self.items) {
        item.checked = (item == checkedItem);
    }
    self.sourceItem.text = checkedItem.title;
}

- (int)checkedIndex
{
    BaseSettingItem *item = self.checkedItem;
    return item ? (int)[self.items indexOfObject:item] : -1;
}

- (void)setCheckedIndex:(int)checkedIndex
{
    if (checkedIndex <0 || checkedIndex >= self.items.count) return;
    
    self.checkedItem = self.items[checkedIndex];
}

- (void)setItems:(NSArray *)items
{
    [super setItems:items];
    
    self.checkedIndex = self.checkedIndex;
    self.checkedItem = self.checkedItem;
    self.sourceItem = self.sourceItem;
}

- (void)setSourceItem:(BaseSettingItem *)sourceItem
{
    _sourceItem = sourceItem;
    
    for (BaseSettingItem *item in self.items) {
        item.checked = [item.title isEqualToString:sourceItem.text];
    }
}
@end
