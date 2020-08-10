//
//  KindModel.m
//
//  Created by   on 17/1/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "KindModel.h"


NSString *const kKindModelPathName = @"path_name";
NSString *const kKindModelShowInNav = @"show_in_nav";
NSString *const kKindModelStyle = @"style";
NSString *const kKindModelTypeImg = @"type_img";
NSString *const kKindModelMeasureUnit = @"measure_unit";
NSString *const kKindModelCategoryIndex = @"category_index";
NSString *const kKindModelCatIndexRightad = @"cat_index_rightad";
NSString *const kKindModelTemplateFile = @"template_file";
NSString *const kKindModelParentId = @"parent_id";
NSString *const kKindModelIsShow = @"is_show";
NSString *const kKindModelCatId = @"cat_id";
NSString *const kKindModelFilterAttr = @"filter_attr";
NSString *const kKindModelKeywords = @"keywords";
NSString *const kKindModelSortOrder = @"sort_order";
NSString *const kKindModelCategoryIndexDwt = @"category_index_dwt";
NSString *const kKindModelBrandQq = @"brand_qq";
NSString *const kKindModelCatName = @"cat_name";
NSString *const kKindModelCatDesc = @"cat_desc";
NSString *const kKindModelIndexDwtFile = @"index_dwt_file";
NSString *const kKindModelGrade = @"grade";
NSString *const kKindModelCatAdurl1 = @"cat_adurl_1";
NSString *const kKindModelCatAdurl2 = @"cat_adurl_2";
NSString *const kKindModelShowInIndex = @"show_in_index";
NSString *const kKindModelCatNameimg = @"cat_nameimg";
NSString *const kKindModelShowGoodsNum = @"show_goods_num";
NSString *const kKindModelAttrWwwecshop68com = @"attr_wwwecshop68com";
NSString *const kKindModelCatAdimg2 = @"cat_adimg_2";
NSString *const kKindModelCatAdimg1 = @"cat_adimg_1";
NSString *const kKindModelIsVirtual = @"is_virtual";


@interface KindModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation KindModel

@synthesize pathName = _pathName;
@synthesize showInNav = _showInNav;
@synthesize style = _style;
@synthesize typeImg = _typeImg;
@synthesize measureUnit = _measureUnit;
@synthesize categoryIndex = _categoryIndex;
@synthesize catIndexRightad = _catIndexRightad;
@synthesize templateFile = _templateFile;
@synthesize parentId = _parentId;
@synthesize isShow = _isShow;
@synthesize catId = _catId;
@synthesize filterAttr = _filterAttr;
@synthesize keywords = _keywords;
@synthesize sortOrder = _sortOrder;
@synthesize categoryIndexDwt = _categoryIndexDwt;
@synthesize brandQq = _brandQq;
@synthesize catName = _catName;
@synthesize catDesc = _catDesc;
@synthesize indexDwtFile = _indexDwtFile;
@synthesize grade = _grade;
@synthesize catAdurl1 = _catAdurl1;
@synthesize catAdurl2 = _catAdurl2;
@synthesize showInIndex = _showInIndex;
@synthesize catNameimg = _catNameimg;
@synthesize showGoodsNum = _showGoodsNum;
@synthesize attrWwwecshop68com = _attrWwwecshop68com;
@synthesize catAdimg2 = _catAdimg2;
@synthesize catAdimg1 = _catAdimg1;
@synthesize isVirtual = _isVirtual;


+ (NSMutableArray *)modelListWithArray:(NSArray *)array
{
    NSMutableArray *muArray = [NSMutableArray array];
    
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         KindModel *firstKindModel = [KindModel modelObjectWithDictionary:obj];
         firstKindModel.isFolded = NO;
         NSArray *secondList = obj[@"second_list"];
         if (secondList && secondList.count)
         {
             [secondList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  KindModel *secondKindModel = [KindModel modelObjectWithDictionary:obj];
                  secondKindModel.isFolded = YES;
                  
                  
                  NSArray *thirdList = obj[@"third_list"];
                  if (thirdList && thirdList.count)
                  {
                      [thirdList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                       {
                           KindModel *thirdKindModel = [KindModel modelObjectWithDictionary:obj];
                           [secondKindModel.nextLevelListArray addObject:thirdKindModel];
                       }];
                  }
                  [firstKindModel.nextLevelListArray addObject:secondKindModel];
                  
                  

              }];
         }
         
         [muArray addObject:firstKindModel];
     }];
    

    
    
    
    return muArray;
}


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
            self.pathName = [self objectOrNilForKey:kKindModelPathName fromDictionary:dict];
            self.showInNav = [self objectOrNilForKey:kKindModelShowInNav fromDictionary:dict];
            self.style = [self objectOrNilForKey:kKindModelStyle fromDictionary:dict];
            self.typeImg = [self objectOrNilForKey:kKindModelTypeImg fromDictionary:dict];
            self.measureUnit = [self objectOrNilForKey:kKindModelMeasureUnit fromDictionary:dict];
            self.categoryIndex = [self objectOrNilForKey:kKindModelCategoryIndex fromDictionary:dict];
            self.catIndexRightad = [self objectOrNilForKey:kKindModelCatIndexRightad fromDictionary:dict];
            self.templateFile = [self objectOrNilForKey:kKindModelTemplateFile fromDictionary:dict];
            self.parentId = [self objectOrNilForKey:kKindModelParentId fromDictionary:dict];
            self.isShow = [self objectOrNilForKey:kKindModelIsShow fromDictionary:dict];
            self.catId = [self objectOrNilForKey:kKindModelCatId fromDictionary:dict];
            self.filterAttr = [self objectOrNilForKey:kKindModelFilterAttr fromDictionary:dict];
            self.keywords = [self objectOrNilForKey:kKindModelKeywords fromDictionary:dict];
            self.sortOrder = [self objectOrNilForKey:kKindModelSortOrder fromDictionary:dict];
            self.categoryIndexDwt = [self objectOrNilForKey:kKindModelCategoryIndexDwt fromDictionary:dict];
            self.brandQq = [self objectOrNilForKey:kKindModelBrandQq fromDictionary:dict];
            self.catName = [self objectOrNilForKey:kKindModelCatName fromDictionary:dict];
            self.catDesc = [self objectOrNilForKey:kKindModelCatDesc fromDictionary:dict];
            self.indexDwtFile = [self objectOrNilForKey:kKindModelIndexDwtFile fromDictionary:dict];
            self.grade = [self objectOrNilForKey:kKindModelGrade fromDictionary:dict];
            self.catAdurl1 = [self objectOrNilForKey:kKindModelCatAdurl1 fromDictionary:dict];
            self.catAdurl2 = [self objectOrNilForKey:kKindModelCatAdurl2 fromDictionary:dict];
            self.showInIndex = [self objectOrNilForKey:kKindModelShowInIndex fromDictionary:dict];
            self.catNameimg = [self objectOrNilForKey:kKindModelCatNameimg fromDictionary:dict];
            self.showGoodsNum = [self objectOrNilForKey:kKindModelShowGoodsNum fromDictionary:dict];
            self.attrWwwecshop68com = [self objectOrNilForKey:kKindModelAttrWwwecshop68com fromDictionary:dict];
            self.catAdimg2 = [self objectOrNilForKey:kKindModelCatAdimg2 fromDictionary:dict];
            self.catAdimg1 = [self objectOrNilForKey:kKindModelCatAdimg1 fromDictionary:dict];
            self.isVirtual = [self objectOrNilForKey:kKindModelIsVirtual fromDictionary:dict];
    }
    
    return self;
    
}

- (NSMutableArray *)nextLevelListArray
{
    if (_nextLevelListArray == nil)
    {
        _nextLevelListArray = [NSMutableArray array];
    }
    
    return _nextLevelListArray;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.pathName forKey:kKindModelPathName];
    [mutableDict setValue:self.showInNav forKey:kKindModelShowInNav];
    [mutableDict setValue:self.style forKey:kKindModelStyle];
    [mutableDict setValue:self.typeImg forKey:kKindModelTypeImg];
    [mutableDict setValue:self.measureUnit forKey:kKindModelMeasureUnit];
    [mutableDict setValue:self.categoryIndex forKey:kKindModelCategoryIndex];
    [mutableDict setValue:self.catIndexRightad forKey:kKindModelCatIndexRightad];
    [mutableDict setValue:self.templateFile forKey:kKindModelTemplateFile];
    [mutableDict setValue:self.parentId forKey:kKindModelParentId];
    [mutableDict setValue:self.isShow forKey:kKindModelIsShow];
    [mutableDict setValue:self.catId forKey:kKindModelCatId];
    [mutableDict setValue:self.filterAttr forKey:kKindModelFilterAttr];
    [mutableDict setValue:self.keywords forKey:kKindModelKeywords];
    [mutableDict setValue:self.sortOrder forKey:kKindModelSortOrder];
    [mutableDict setValue:self.categoryIndexDwt forKey:kKindModelCategoryIndexDwt];
    [mutableDict setValue:self.brandQq forKey:kKindModelBrandQq];
    [mutableDict setValue:self.catName forKey:kKindModelCatName];
    [mutableDict setValue:self.catDesc forKey:kKindModelCatDesc];
    [mutableDict setValue:self.indexDwtFile forKey:kKindModelIndexDwtFile];
    [mutableDict setValue:self.grade forKey:kKindModelGrade];
    [mutableDict setValue:self.catAdurl1 forKey:kKindModelCatAdurl1];
    [mutableDict setValue:self.catAdurl2 forKey:kKindModelCatAdurl2];
    [mutableDict setValue:self.showInIndex forKey:kKindModelShowInIndex];
    [mutableDict setValue:self.catNameimg forKey:kKindModelCatNameimg];
    [mutableDict setValue:self.showGoodsNum forKey:kKindModelShowGoodsNum];
    [mutableDict setValue:self.attrWwwecshop68com forKey:kKindModelAttrWwwecshop68com];
    [mutableDict setValue:self.catAdimg2 forKey:kKindModelCatAdimg2];
    [mutableDict setValue:self.catAdimg1 forKey:kKindModelCatAdimg1];
    [mutableDict setValue:self.isVirtual forKey:kKindModelIsVirtual];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.pathName = [aDecoder decodeObjectForKey:kKindModelPathName];
    self.showInNav = [aDecoder decodeObjectForKey:kKindModelShowInNav];
    self.style = [aDecoder decodeObjectForKey:kKindModelStyle];
    self.typeImg = [aDecoder decodeObjectForKey:kKindModelTypeImg];
    self.measureUnit = [aDecoder decodeObjectForKey:kKindModelMeasureUnit];
    self.categoryIndex = [aDecoder decodeObjectForKey:kKindModelCategoryIndex];
    self.catIndexRightad = [aDecoder decodeObjectForKey:kKindModelCatIndexRightad];
    self.templateFile = [aDecoder decodeObjectForKey:kKindModelTemplateFile];
    self.parentId = [aDecoder decodeObjectForKey:kKindModelParentId];
    self.isShow = [aDecoder decodeObjectForKey:kKindModelIsShow];
    self.catId = [aDecoder decodeObjectForKey:kKindModelCatId];
    self.filterAttr = [aDecoder decodeObjectForKey:kKindModelFilterAttr];
    self.keywords = [aDecoder decodeObjectForKey:kKindModelKeywords];
    self.sortOrder = [aDecoder decodeObjectForKey:kKindModelSortOrder];
    self.categoryIndexDwt = [aDecoder decodeObjectForKey:kKindModelCategoryIndexDwt];
    self.brandQq = [aDecoder decodeObjectForKey:kKindModelBrandQq];
    self.catName = [aDecoder decodeObjectForKey:kKindModelCatName];
    self.catDesc = [aDecoder decodeObjectForKey:kKindModelCatDesc];
    self.indexDwtFile = [aDecoder decodeObjectForKey:kKindModelIndexDwtFile];
    self.grade = [aDecoder decodeObjectForKey:kKindModelGrade];
    self.catAdurl1 = [aDecoder decodeObjectForKey:kKindModelCatAdurl1];
    self.catAdurl2 = [aDecoder decodeObjectForKey:kKindModelCatAdurl2];
    self.showInIndex = [aDecoder decodeObjectForKey:kKindModelShowInIndex];
    self.catNameimg = [aDecoder decodeObjectForKey:kKindModelCatNameimg];
    self.showGoodsNum = [aDecoder decodeObjectForKey:kKindModelShowGoodsNum];
    self.attrWwwecshop68com = [aDecoder decodeObjectForKey:kKindModelAttrWwwecshop68com];
    self.catAdimg2 = [aDecoder decodeObjectForKey:kKindModelCatAdimg2];
    self.catAdimg1 = [aDecoder decodeObjectForKey:kKindModelCatAdimg1];
    self.isVirtual = [aDecoder decodeObjectForKey:kKindModelIsVirtual];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_pathName forKey:kKindModelPathName];
    [aCoder encodeObject:_showInNav forKey:kKindModelShowInNav];
    [aCoder encodeObject:_style forKey:kKindModelStyle];
    [aCoder encodeObject:_typeImg forKey:kKindModelTypeImg];
    [aCoder encodeObject:_measureUnit forKey:kKindModelMeasureUnit];
    [aCoder encodeObject:_categoryIndex forKey:kKindModelCategoryIndex];
    [aCoder encodeObject:_catIndexRightad forKey:kKindModelCatIndexRightad];
    [aCoder encodeObject:_templateFile forKey:kKindModelTemplateFile];
    [aCoder encodeObject:_parentId forKey:kKindModelParentId];
    [aCoder encodeObject:_isShow forKey:kKindModelIsShow];
    [aCoder encodeObject:_catId forKey:kKindModelCatId];
    [aCoder encodeObject:_filterAttr forKey:kKindModelFilterAttr];
    [aCoder encodeObject:_keywords forKey:kKindModelKeywords];
    [aCoder encodeObject:_sortOrder forKey:kKindModelSortOrder];
    [aCoder encodeObject:_categoryIndexDwt forKey:kKindModelCategoryIndexDwt];
    [aCoder encodeObject:_brandQq forKey:kKindModelBrandQq];
    [aCoder encodeObject:_catName forKey:kKindModelCatName];
    [aCoder encodeObject:_catDesc forKey:kKindModelCatDesc];
    [aCoder encodeObject:_indexDwtFile forKey:kKindModelIndexDwtFile];
    [aCoder encodeObject:_grade forKey:kKindModelGrade];
    [aCoder encodeObject:_catAdurl1 forKey:kKindModelCatAdurl1];
    [aCoder encodeObject:_catAdurl2 forKey:kKindModelCatAdurl2];
    [aCoder encodeObject:_showInIndex forKey:kKindModelShowInIndex];
    [aCoder encodeObject:_catNameimg forKey:kKindModelCatNameimg];
    [aCoder encodeObject:_showGoodsNum forKey:kKindModelShowGoodsNum];
    [aCoder encodeObject:_attrWwwecshop68com forKey:kKindModelAttrWwwecshop68com];
    [aCoder encodeObject:_catAdimg2 forKey:kKindModelCatAdimg2];
    [aCoder encodeObject:_catAdimg1 forKey:kKindModelCatAdimg1];
    [aCoder encodeObject:_isVirtual forKey:kKindModelIsVirtual];
}

- (id)copyWithZone:(NSZone *)zone
{
    KindModel *copy = [[KindModel alloc] init];
    
    if (copy) {

        copy.pathName = [self.pathName copyWithZone:zone];
        copy.showInNav = [self.showInNav copyWithZone:zone];
        copy.style = [self.style copyWithZone:zone];
        copy.typeImg = [self.typeImg copyWithZone:zone];
        copy.measureUnit = [self.measureUnit copyWithZone:zone];
        copy.categoryIndex = [self.categoryIndex copyWithZone:zone];
        copy.catIndexRightad = [self.catIndexRightad copyWithZone:zone];
        copy.templateFile = [self.templateFile copyWithZone:zone];
        copy.parentId = [self.parentId copyWithZone:zone];
        copy.isShow = [self.isShow copyWithZone:zone];
        copy.catId = [self.catId copyWithZone:zone];
        copy.filterAttr = [self.filterAttr copyWithZone:zone];
        copy.keywords = [self.keywords copyWithZone:zone];
        copy.sortOrder = [self.sortOrder copyWithZone:zone];
        copy.categoryIndexDwt = [self.categoryIndexDwt copyWithZone:zone];
        copy.brandQq = [self.brandQq copyWithZone:zone];
        copy.catName = [self.catName copyWithZone:zone];
        copy.catDesc = [self.catDesc copyWithZone:zone];
        copy.indexDwtFile = [self.indexDwtFile copyWithZone:zone];
        copy.grade = [self.grade copyWithZone:zone];
        copy.catAdurl1 = [self.catAdurl1 copyWithZone:zone];
        copy.catAdurl2 = [self.catAdurl2 copyWithZone:zone];
        copy.showInIndex = [self.showInIndex copyWithZone:zone];
        copy.catNameimg = [self.catNameimg copyWithZone:zone];
        copy.showGoodsNum = [self.showGoodsNum copyWithZone:zone];
        copy.attrWwwecshop68com = [self.attrWwwecshop68com copyWithZone:zone];
        copy.catAdimg2 = [self.catAdimg2 copyWithZone:zone];
        copy.catAdimg1 = [self.catAdimg1 copyWithZone:zone];
        copy.isVirtual = [self.isVirtual copyWithZone:zone];
    }
    
    return copy;
}


@end
