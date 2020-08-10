//
//  CoreDataManager.h
//  SURE
//
//  Created by 王玉龙 on 16/11/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject
/**
 *  单例的初始化类方法
 *  @return CoreDataManager
 */
+ (CoreDataManager *)defaultManager;
/**
 *  添加一个对象模型到数据库中
 *  @param name       模型类的名字
 *  @param dictionary 需要对应赋值的属性
 */

- (void)addManagedObjectModelWithName:(NSString *)name dictionary:(NSDictionary *)dictionary;
/**
 *  查询对象模型
 *  @param name      模型类的名字
 *  @param predicate 创建一个谓词
 *  @param sortkeys  用来排序的Keys(注意是个数组)
 *  @return 返回查到的对象, 在外部使用时应与name对应
 */

/**
 *  查询对象模型
 *  @param name      模型类的名字
 *  @param predicate 创建一个谓词
 *  @param sortkeys  用来排序的Keys(注意是个数组)
 *  @return 返回查到的对象, 在外部使用时应与name对应
 */
- (NSArray *)fetchManagedObjectModelWithName:(NSString *)name predicate:(NSPredicate *)predicate sortKeys:(NSArray *)sortkeys;
/**
 *  删除对象模型
 *  @param models 对象模型数组(注意是数组, 尽管是删除一个也要数组)
 */
- (void)deleteAllManagedObjectModels:(NSArray *)models;





@end
