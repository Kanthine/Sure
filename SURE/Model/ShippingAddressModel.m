//
//  ShippingAddressModel.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShippingAddressModel.h"

#import "AppDelegate.h"
#import "AdressListLocalization.h"

#import "ShippingAdress+CoreDataProperties.h"


@implementation ShippingAddressModel

+ (ShippingAddressModel *)parserDataWithDictionary:(NSDictionary *)dictionary CityList:(NSArray *)cityArray
{
    NSString *nameString = [dictionary objectForKey:@"consignee"];
    NSString *phoneString = [dictionary objectForKey:@"mobile"];
    NSString *addressString = [dictionary objectForKey:@"address"];
    
    NSString *address_name = [dictionary objectForKey:@"address_name"];
    NSString *provinceID = [dictionary objectForKey:@"province"];
    NSString *cityID = [dictionary objectForKey:@"city"];
    NSString *districtID = [dictionary objectForKey:@"district"];
    NSString *address_id = [dictionary objectForKey:@"address_id"];

    
    
    NSLog(@"ShippingAddressModel == %@",[ConsoleOutPutChinese outPutChineseWithObj:dictionary]);
    
    NSPredicate *provencePredicate = [NSPredicate predicateWithFormat:@"region_id LIKE %@",provinceID];
    NSArray *provenceArray = [cityArray filteredArrayUsingPredicate:provencePredicate];
    
    NSString *province;
    NSString *city ;
    NSString *district;
    
    if (provenceArray && provenceArray.count > 0)
    {
        NSDictionary *provenceDict = provenceArray[0];
        province = [provenceDict objectForKey:@"region_name"];
        
        NSArray *firstArray = [provenceDict objectForKey:@"childArray"];
        NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"region_id LIKE %@",cityID];
        NSArray *secondResultwArray = [firstArray filteredArrayUsingPredicate:cityPredicate];
        
        
        if (secondResultwArray && secondResultwArray.count > 0)
        {
            NSDictionary *cityDict = secondResultwArray[0];
            city = [cityDict objectForKey:@"region_name"];
            
            NSArray *secondArray = [cityDict objectForKey:@"childArray"];
            
            NSPredicate *areaPredicate = [NSPredicate predicateWithFormat:@"region_id LIKE %@",districtID];
            NSArray *areaArray = [secondArray filteredArrayUsingPredicate:areaPredicate];
            if (areaArray && areaArray.count > 0)
            {
                NSDictionary *arreaDict = areaArray[0];
                district = [arreaDict objectForKey:@"region_name"];
            }
            
        }
    }
    
    NSString *nameStr;
    if ([province isEqualToString:city])
    {
        nameStr = [NSString stringWithFormat:@"%@ %@",province,district];
    }
    else if (district == nil || [district isEqualToString:@""])
    {
        nameStr = [NSString stringWithFormat:@"%@ %@",province,city];
    }
    else
    {
        nameStr = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
    }
    
    nameStr = [NSString stringWithFormat:@"%@ %@",nameStr,addressString];
    
    ShippingAddressModel *addressModel = [[ShippingAddressModel alloc]init];
    addressModel.nameString = nameString;
    addressModel.phoneString = phoneString;
    addressModel.addressString = addressString;
    addressModel.address_id = address_id;
    addressModel.address_name = address_name;
    addressModel.provinceID = provinceID;
    addressModel.cityID = cityID;
    
    addressModel.districtID = districtID;
    addressModel.province = province;
    addressModel.city = city;
    addressModel.district = district;
    
    addressModel.provinceCityName = nameStr;
    
    if ([address_name isEqualToString:@"收货地址"])
    {
        addressModel.isDefaultAdress = NO;
    }
    else if ([address_name isEqualToString:@"默认地址"])
    {
        addressModel.isDefaultAdress = YES;
    }
    
    

    [ShippingAddressModel insertShippingAdressWithModel:addressModel];
    
    return addressModel;
}

/*
 address_id : 16
 　　　　　　address_name :
 　　　　　　user_id : 1
 　　　　　　consignee : anan
 　　　　　　email : cuibo@68ecshop.com
 　　　　　　country : 1
 　　　　　　province : 10
 　　　　　　city : 145
 　　　　　　district : 1194
 　　　　　　address : 森林逸城B区
 　　　　　　zipcode :
 　　　　　　tel : --
 　　　　　　mobile : 18630360371
 　　　　　　sign_building :
 　　　　　　best_time :
 */

+ (NSMutableArray *)parserDataWithShippingAddressArray:(NSArray *)addressArray
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    NSString *filePath = [AdressListLocalization getCityListPath];
    
    NSArray *cityListArray = [[NSArray alloc]initWithContentsOfFile:filePath];
    
    for (int i = 0; i < addressArray.count; i ++)
    {
        NSDictionary *attributeDict = addressArray[i];
        
        ShippingAddressModel *addressModel = [ShippingAddressModel parserDataWithDictionary:attributeDict CityList:cityListArray];       
        
        [parserArray addObject:addressModel];
        
    }
    
    return parserArray;
}

+ (void)insertShippingAdressWithModel:(ShippingAddressModel *)adressModel
{
    NSArray *queryArray = [ShippingAddressModel queryShippingAdressWithModel:adressModel];
    
    if ([queryArray lastObject])//重复数据进行覆盖
    {
        [ShippingAddressModel updateShippingAdressWithModel:adressModel];
        
        return;
    }
    
  
//    ShippingAdress *adressEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    ShippingAdress *adressEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.managedObjectContext];


    
    adressEntity.isDefaultAdress = adressModel.isDefaultAdress;
    adressEntity.nameString = adressModel.nameString;
    adressEntity.phoneString  = adressModel.phoneString;
    adressEntity.addressString = adressModel. addressString;
    adressEntity.address_name = adressModel.address_name;
    adressEntity.address_id = adressModel.address_id;
    adressEntity.provinceID = adressModel.provinceID;
    adressEntity.cityID = adressModel.cityID;
    adressEntity.districtID = adressModel.districtID;
    adressEntity.province = adressModel.province;
    adressEntity.city = adressModel.city;
    adressEntity.district = adressModel.district;
    adressEntity.provinceCityName = adressModel.provinceCityName;
    
    
    NSLog(@"adressEntity ========  %@",adressEntity);
    NSLog(@"managedObjectContext ======== %@",APPDELEGETE.managedObjectContext);
//    NSLog(@"adressEntity ========  %@",adressEntity);

    
    
    [APPDELEGETE saveContext];
}

+ (void)deletaShippingAdressWithModel:(ShippingAddressModel *)adressModel
{
    NSFetchRequest *request = [ShippingAdress fetchRequest];
    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    //创建一个检索条件的谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"address_id", adressModel.address_id];
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
+ (NSArray *)queryShippingAdressWithModel:(ShippingAddressModel *)adressModel
{
    //创建取回数据的请求
    NSFetchRequest *request = [ShippingAdress fetchRequest];
    //ascending 上升
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"address_id" ascending:NO];
    request.sortDescriptors = @[sort];
    

    
    
    //说明要检索哪种类型的实体对象 ： entityForName
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    if (adressModel)
    {
        //创建一个检索条件的谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"address_id", adressModel.address_id];
        [request setPredicate:predicate];
    }
    
    [request setEntity:entity];
    
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
//    NSArray *resultArray = [APPDELEGETE.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSArray *resultArray = [APPDELEGETE.managedObjectContext executeFetchRequest:request error:&error];

    
    NSLog(@"queryShippingAdress == %ld",resultArray.count);

    return resultArray;
}


+ (void)updateShippingAdressWithModel:(ShippingAddressModel *)adressModel
{
    NSFetchRequest *fetchRequest = [ShippingAdress fetchRequest];
    
    
//    NSEntityDescription * entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    [fetchRequest setEntity:entity];
    
    //创建一个检索条件的谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"address_id", adressModel.address_id];
    [fetchRequest setPredicate:predicate];

    
    NSError * requestError = nil;
//    NSArray * modelArray = [APPDELEGETE.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&requestError];
    
    NSArray *modelArray = [APPDELEGETE.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];

    
    if ([modelArray count] > 0)
    {
        
        ShippingAdress *adressEntity = [modelArray lastObject];
        
        adressEntity.isDefaultAdress = adressModel.isDefaultAdress;
        adressEntity.nameString = adressModel.nameString;
        adressEntity.phoneString  = adressModel.phoneString;
        adressEntity.addressString = adressModel. addressString;
        adressEntity.address_name = adressModel.address_name;
        adressEntity.address_id = adressModel.address_id;
        adressEntity.provinceID = adressModel.provinceID;
        adressEntity.cityID = adressModel.cityID;
        adressEntity.districtID = adressModel.districtID;
        adressEntity.province = adressModel.province;
        adressEntity.city = adressModel.city;
        adressEntity.district = adressModel.district;
        adressEntity.provinceCityName = adressModel.provinceCityName;
        
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

+ (void)deletaAllShippingAdress
{
    NSFetchRequest *request = [ShippingAdress fetchRequest];
    
    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.persistentContainer.viewContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingAdress" inManagedObjectContext:APPDELEGETE.managedObjectContext];

    [request setEntity:entity];
    
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


@end
