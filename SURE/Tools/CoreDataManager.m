//
//  CoreDataManager.m
//  SURE
//
//  Created by 王玉龙 on 16/11/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CoreDataManager.h"

#import <CoreData/CoreData.h>

@interface CoreDataManager ()

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel * managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@end

@implementation CoreDataManager

static CoreDataManager * s_defaultManager = nil;
+ (CoreDataManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_defaultManager = [[CoreDataManager alloc] init];
    });
    return s_defaultManager;
}
/**
 *  单例的初始化方法, 在init方法中初始化单例类持有的对象
 *  @return 初始化后的对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加观察者, 当ManagerObjectContext发生变化时调用saveContext方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    return self;
}

- (void)addManagedObjectModelWithName:(NSString *)name dictionary:(NSDictionary *)dictionary
{
    NSManagedObject * managerObject = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
    [managerObject setValuesForKeysWithDictionary:dictionary];
}

- (NSArray *)fetchManagedObjectModelWithName:(NSString *)name predicate:(NSPredicate *)predicate sortKeys:(NSArray *)sortkeys
{
    // 实例化查询请求
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:name];
    // 谓词搜索如果没有谓词, 那么默认查询全部
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    // 如果没有用来排序的key, 那么默认不排序
    if (sortkeys) {
        // 如果有排序的Key就先创建一个数组来接收多个NSSortDescriptor对象(尽管是一个, 因为setSortDescriptors:方法需要数组作为参数)
        NSMutableArray * sortDescriptorKeys = [NSMutableArray new];
        // 遍历所有的用来排序的key
        for (NSString * key in sortkeys) {
            // 每有一个Key, 就使用该key来创建一个NSSortDescriptor
            NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
            // 在sortDescriptorKeys数组中添加一个NSSortDescriptor元素
            [sortDescriptorKeys addObject:sortDescriptor];
        }
        // 查询请求设置排序方式
        [fetchRequest setSortDescriptors:sortDescriptorKeys];
    }
    
    // 使用数组来接收查询到的内容
    NSArray * fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    // 如果数组为nil
    if (fetchedObjects == nil) {
        // 创建一个新的数组返回, 在外部去做判断
        fetchedObjects = [NSArray new];
    }
    // 返回查找到的数组
    return fetchedObjects;
}
- (void)deleteAllManagedObjectModels:(NSArray *)models {
    // 遍历删除传进来数组中的元素对应的表内容
    for (NSManagedObject * object in models) {
        // 使用管理者删除对象, 数组中的元素并没有缺少
        [self.managedObjectContext deleteObject:object];
    }
}


#pragma mark - Core Data stack
- (NSURL *)applicationDocumentsDirectory {
    NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
/**
 *  模型器的懒加载方法
 *  @return 唯一的模型器
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (!_managedObjectModel) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PalmEfamily" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}
/**
 *  链接器的懒加载方法
 *  @return 唯一的链接器对象
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PalmEfamily.sqlite"];
        //        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSInferMappingModelAutomaticallyOption : @YES, NSMigratePersistentStoresAutomaticallyOption : @YES } error:nil];
    }
    return _persistentStoreCoordinator;
}
/**
 *  管理者的懒加载方法
 *  @return 唯一的管理者对象
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    return _managedObjectContext;
}
/**
 *  ManagerObjectContext的保存方法
 */
- (void)saveContext
{
    [self.managedObjectContext save:nil];
}

@end
