//
//  CollectModelDAO.m
//  SURE
//
//  Created by 王玉龙 on 16/12/13.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CollectModelDAO.h"
#import "AFNetDiskCache.h"

#import "CollectProductCoreModel+CoreDataProperties.h"

@implementation CollectProductModelDAO

+ (void)insertCollectProductWithModel:(CollectProductModel *)productModel
{
    NSArray *queryArray = [CollectProductModelDAO queryCollectProductWithModel:productModel];
    
    if ([queryArray lastObject])//重复数据进行覆盖
    {
        //        [ShippingAddressDAO updateShippingAdressWithModel:adressModel];
        
        return;
    }
    
//    CollectProductCoreModel *modelEntity = [NSEntityDescription insertNewObjectForEntityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    
    CollectProductCoreModel *modelEntity = [NSEntityDescription insertNewObjectForEntityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    
    modelEntity.name = productModel.productName;
    modelEntity.productID = productModel.productID;
    modelEntity.image  = productModel.imageStr;
    modelEntity.price = productModel.productPrice;
    modelEntity.month = productModel.compareMonth;
    modelEntity.collectTime = productModel.collectTime;

    [APPDELEGETE saveContext];
}


+ (void)deletaCollectProductWithModel:(CollectProductModel *)productModel
{
    NSFetchRequest *request = [CollectProductCoreModel fetchRequest];
    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    //创建一个检索条件的谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"productID", productModel.productID];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    
//    NSArray *array = [APPDELEGETE.persistentContainer.viewContext executeFetchRequest:request error:&error];
    NSArray *array = [APPDELEGETE.managedObjectContext executeFetchRequest:request error:&error];

    if (!error && array && array.count)
    {
        for (NSManagedObject *info in array)
        {
            //删除数据
             [APPDELEGETE.managedObjectContext deleteObject:info];
//            [APPDELEGETE.persistentContainer.viewContext deleteObject:info];
        }
        
        if (! [APPDELEGETE.managedObjectContext save:&error])
        {
            NSLog(@"error : %@",error.localizedDescription);
        }
        else
        {
            
        }
    }
}

//查 参数为空时 检索全部数据
+ (NSArray *)queryCollectProductWithModel:(CollectProductModel *)productModel
{
    //创建取回数据的请求
    NSFetchRequest *request = [CollectProductCoreModel fetchRequest];
    //ascending 上升
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"collectTime" ascending:NO];
    request.sortDescriptors = @[sort];
    
    
    
    //说明要检索哪种类型的实体对象 ： entityForName
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    if (productModel)
    {
        //创建一个检索条件的谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"productID", productModel.productID];
        [request setPredicate:predicate];
    }
    
    [request setEntity:entity];
    
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *resultArray = [APPDELEGETE.managedObjectContext executeFetchRequest:request error:&error];
    
    
    NSLog(@"queryCollectProductWithModel == %ld",resultArray.count);
    
    return resultArray;
}


+ (void)updateCollectProductWithModel:(CollectProductModel *)productModel
{
    
    NSFetchRequest *fetchRequest = [CollectProductCoreModel fetchRequest];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //创建一个检索条件的谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"productID", productModel.productID];
    [fetchRequest setPredicate:predicate];
    
    
    NSError * requestError = nil;
    NSArray * modelArray = [APPDELEGETE.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    
    
    if ([modelArray count] > 0)
    {
        
        CollectProductCoreModel *modelEntity = [modelArray lastObject];
        
        modelEntity.name = productModel.productName;
        modelEntity.productID = productModel.productID;
        modelEntity.image  = productModel.imageStr;
        modelEntity.price = productModel.productPrice;
        modelEntity.month = productModel.compareMonth;
        modelEntity.collectTime = productModel.collectTime;
        
        NSError * savingError = nil;
        if ([APPDELEGETE.managedObjectContext save:&savingError])
        {
            NSLog(@"successfully saved the context");
            
        }
        else
        {
            NSLog(@"failed to save the context error = %@", savingError);
        }
        
        
    }
    else
    {
        NSLog(@"could not find any person entity in the context");
    }
}

+ (void)deletaAllCollectProduct
{
    NSFetchRequest *request = [CollectProductCoreModel fetchRequest];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProductCoreModel" inManagedObjectContext:APPDELEGETE.managedObjectContext];
    [request setEntity:entity];
    
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    
    NSArray *array = [APPDELEGETE.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!error && array && array.count)
    {
        for (NSManagedObject *info in array)
        {
            //删除数据
            [APPDELEGETE.managedObjectContext deleteObject:info];
        }
        
        if (! [APPDELEGETE.managedObjectContext save:&error])
        {
            NSLog(@"error : %@",error.localizedDescription);
        }
        else
        {
            
        }
    }
    
}

+ (void)deleteLocalityJsonDataWithModel:(CollectProductModel *)productModel
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AttentionList];
    
    NSDictionary *parDict = @{@"user_id":account.userId,@"parent_id":@"",@"follow_type":@"3"};
    
    NSDictionary *resDict = [AFNetDiskCache cahceResponseWithURL:urlString parameters:parDict];
    
    NSArray *array = [[resDict objectForKey:@"data"] objectForKey:@"result"];

    
    
    NSMutableArray *jsonArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([[obj objectForKey:@"parent_id"] isEqualToString:productModel.productID] == NO)
        {
            [jsonArray addObject:obj];
        }
    }];
    
    
    
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:resDict[@"error_flag"] forKey:@"error_flag"];
    [jsonDict setObject:resDict[@"result_code"] forKey:@"result_code"];
    [jsonDict setObject:resDict[@"result_msg"] forKey:@"result_msg"];
    [jsonDict setObject:@{@"result":jsonArray} forKey:@"data"];
    
    [AFNetDiskCache cacheResponseObject:jsonDict request:urlString parameters:parDict];
    
    BOOL isYes = [NSJSONSerialization isValidJSONObject:jsonDict];
    
    if (isYes)
    {
        NSLog(@"可以转换");
    }
    else
    {
        NSLog(@"JSON数据生成失败，请检查数据格式");
    }
}


@end
