

#import "FMDBTool.h"
#import "BaseModel.h"
#import <objc/message.h>

/**
 *  SQL类型
 */
#define DBText  @"text"
#define DBInt   @"integer"
#define DBFloat @"real"
#define DBData  @"blob"



@implementation FMDBTool
static FMDatabaseQueue *_queue;

#pragma mark -初始化
+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DEFAULT_DB_NAME];
   // 1.创建队列
    _queue = [[FMDatabaseQueue alloc]initWithPath:path];
    
  
}
#pragma mark -查询
+(NSInteger)querySum:(NSString*)sql{


   __block NSInteger sum=0;
    [_queue inDatabase:^(FMDatabase *db) {
        int count=[db intForQuery:sql];
        sum=count;
    }];
    
    return sum;
}
/**
 *  查询
 *
 *  @param className 类名字
 *  @param where     条件:where name = '张三' AND age <10 LIMIT 10
 *  @param success   回调查询后的数组里面是class的对象模型数组
 */
+(NSMutableArray*)queryClass:(Class)className
                where:(NSString*)where
            success:(FMDBToolQueryArraySuccess)success{
    
  
        
    NSString *querySql=nil;
    
    if ([where hasPrefix:@"SELECT"]) {
        querySql=where;
    }else if (!where) {
        querySql=[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(className)];

    }else{
        querySql=[NSString stringWithFormat:@"SELECT * FROM %@ %@",NSStringFromClass(className),where];
    }
    
    
    NSMutableArray * arrayM=[NSMutableArray array];
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[[FMResultSet alloc]init];
        rs=[db executeQuery:querySql];
        
        //3.对象数组
        while ([rs next]){
            
            unsigned int count;
            unsigned int count2;
            objc_property_t *properties1 = class_copyPropertyList(className, &count);
            objc_property_t *properties2 =class_copyPropertyList([className superclass],&count2);
            
            id obj=[[className alloc]init];
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties1[i];
                NSString * key = [FMDBTool dbNameConvertFromObjc_property_t:property];
                if ([[rs objectForKeyedSubscript:key] isKindOfClass:[NSNull class]]||![rs objectForKeyedSubscript:key]) {
                    continue;
                }
                [obj setValue:[rs objectForKeyedSubscript:key] forKey:key];
            }
            
            for (int i = 0; i < count2; i++) {
                objc_property_t property = properties2[i];
                NSString * key = [FMDBTool dbNameConvertFromObjc_property_t:property];
                if ([[rs objectForKeyedSubscript:key] isKindOfClass:[NSNull class]]||![rs objectForKeyedSubscript:key]) {
                    continue;
                }
                [obj setValue:[rs objectForKeyedSubscript:key] forKey:key];
            }
            
            
            [arrayM addObject:obj];

            
            
            
            
            
        }
        [rs close];

    }];
  
            //结束循环
    return arrayM;
}
+(void)checkExistPropertyAndImport:(NSString*)key
                              type:(NSString*)type
                         className:(NSString*)className{
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSString * condition=[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",className,key,type];
        BOOL success = [db executeUpdate:condition];
        NSAssert(success, @"alter table failed: %@", [db lastErrorMessage]);
    }];
    


}

#pragma mark -删除
/**
 *  删除数据
 *
 *  @param obj   对象
 *  @param where 判断语句 ，如WHERE Name='Anmy'
        复杂一点可以有WHERE Name='Anmy' AND id='455421'
 *
 *  @return BOOL
 */
+ (BOOL)deleteObject:(NSObject*)obj
                 where:(NSString*)where{
    
    NSString * deleteSql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",NSStringFromClass(obj.class),where];
    __block BOOL isSuccess=NO;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 1.获得需要存储的数据
        // 2.存储数据
        isSuccess= [db executeUpdate:deleteSql];
    }];
    return isSuccess;
}
+(BOOL)CleanTableWithClass:(Class)className
                     where:(NSString*)where{return YES;}

#pragma mark -更新数据
/**
 *  更新数据
 *
 *  @param obj   对象
 *  @param where 判断语句 ，如WHERE Name='Anmy' 
    复杂一点可以有WHERE Name='Anmy' AND id='455421'
 *
 *  @return BOOL
 */
+ (BOOL)updateDbObject:(Class)className
          propertyName:(NSString*)propertyName
           newProperty:(id)newProperty
                 where:(NSString*)where{
    
    NSString * updateSql=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' %@ ",NSStringFromClass(className),propertyName,newProperty,where];
    __block BOOL isSuccess=NO;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 1.获得需要存储的数据
        // 2.存储数据
        isSuccess= [db executeUpdate:updateSql];
    }];
    return isSuccess;
}
#pragma mark -插入,只需要传入需要的存储的对象
+ (BOOL)insertDbObject:(NSObject*)obj{

    
    
    //如果不存在表就创建
    if (![FMDBTool tableExist:obj.class]) {
        [FMDBTool CreateTableWithClass:obj.class];
    }
    
    
    
    //0.拼接SQL语句
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"insert into "];
    [sql appendString:NSStringFromClass(obj.class)];
    [sql appendString:@"("];
    

    NSMutableArray* keys = [[NSMutableArray alloc] init];
    NSMutableArray* vals = [[NSMutableArray alloc] init];
    
    //1.对象本身
    unsigned int count;
   objc_property_t *properties = class_copyPropertyList(obj.class, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id value=[obj valueForKey:key];
        if (!value) {
            continue;
        }
        [keys addObject:key];
        [vals addObject:value];
        
    }
//    //2.父类
//    unsigned int count2;
////[className superclass]
//    objc_property_t *properties2 =class_copyPropertyList([obj.class superclass], &count2);;
//    for (int i = 0; i < count2; i++) {
//        
//        objc_property_t property = properties2[i];
//        NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        id value=[obj valueForKey:key];
//        if (!value) {
//            continue;
//        }
//        [keys addObject:key];
//        [vals addObject:value];
//
//    }
//
    
    NSMutableArray* newVals = [[NSMutableArray alloc] init];
    for (int i = 0; i<[vals count]; i++) {
        [newVals addObject:[NSString stringWithFormat:@"'%@'", [vals objectAtIndex:i]]];

    }
    NSString * sqls=[NSString stringWithFormat:@"%@%@)values (%@)",sql,[keys componentsJoinedByString:@","],[newVals componentsJoinedByString:@","]];
    

      __block BOOL isSuccess=NO;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 1.获得需要存储的数据
       // 2.存储数据
       isSuccess= [db executeUpdate:sqls];
    }];
    return isSuccess;
}
#pragma mark - 判断一个表是否存在
/*
 * 判断一个表是否存在；
 */
+ (BOOL)tableExist:(Class)aClass {
    
    // 4.创表
    __block BOOL isSuccess=NO;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        isSuccess=[db tableExists:NSStringFromClass(aClass)];
       
    }];
    return isSuccess;

}
#pragma mark -根据类直接创建表
+(BOOL)CreateTableWithClass:(Class)className{
    
    
   
    //0.拼接SQL语句
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"CREATE TABLE "];
    [sql appendString:NSStringFromClass(className)];
    [sql appendString:@"("];
    //1.
     NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0]; //属性列表
    NSMutableArray *primaryKeys = [NSMutableArray arrayWithCapacity:0]; //优先keys
    [FMDBTool class:className getPropertyNameList:propertyArr primaryKeys:primaryKeys];
    NSString *propertyStr = [propertyArr componentsJoinedByString:@","];
    
    [sql appendString:propertyStr];
    
    NSMutableArray *primaryKeysArr = [NSMutableArray array];
    for (NSString *s in primaryKeys) {
        NSString *str = [NSString stringWithFormat:@"\"%@\"", s];
        [primaryKeysArr addObject:str];
    }
    
    NSString *priKeysStr = [primaryKeysArr componentsJoinedByString:@","];
    NSString *primaryKeysStr = [NSString stringWithFormat:@",primary key(%@)", priKeysStr];
    [sql appendString:primaryKeysStr];
    
    [sql appendString:@");"];

  
    // 4.创表
    __block BOOL isSuccess=NO;
    
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        isSuccess=[db executeUpdate:sql];
    }];
    
    return isSuccess;
}
#pragma mark -删除表
+(BOOL)dropTable:(Class)className
           where:(NSString*)where{
    
    NSString * sql=[NSString stringWithFormat:@"DROP TABLE %@",NSStringFromClass(className)];
    
    __block BOOL isSuccess=NO;
    
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback){
        isSuccess=[db executeUpdate:sql];
    }];
    
    return isSuccess;

}

#pragma mark -
/**
 *  根据class拿出所有属性名
 *
 *  @param aClass  class
 *  @param proName propertiesNames
 */
+ (void)class:(Class)aClass getPropertyKeyList:(NSMutableArray *)propertiesNames
{
    @synchronized(self){
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(aClass, &count);
        
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
            [propertiesNames addObject:key];
        }
        
//        if (aClass == [STDbObject class]) {
//            return;
//        }
        [FMDBTool class:[aClass superclass] getPropertyKeyList:propertiesNames];
    }
}

#define kDbId           @"__id__" //要设置key
#define kDbKeySuffix    @"__key__"
+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName primaryKeys:(NSMutableArray *)primaryKeys
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [FMDBTool dbNameConvertFromObjc_property_t:property];
        NSString *type = [FMDBTool dbTypeConvertFromObjc_property_t:property];
        
        NSString *proStr;
        
        if ([key isEqualToString:kDbId]) {
            [primaryKeys addObject:kDbId];
            proStr = [NSString stringWithFormat:@"%@ %@", kDbId, DBInt];
        } else if ([key hasSuffix:kDbKeySuffix]) {
            [primaryKeys addObject:key];
            proStr = [NSString stringWithFormat:@"%@ %@", key, type];
        } else {
            proStr = [NSString stringWithFormat:@"%@ %@", key, type];
        }
        
        [proName addObject:proStr];
    }
    
    free(properties);
    
    if (aClass == [BaseModel class]) {
        return;
    }
    [FMDBTool class:[aClass superclass] getPropertyNameList:proName primaryKeys:primaryKeys];
    
}

#pragma mark -帮助类
/**
 *  把属性类型转化为对应数据库的字段
 *
 *  @param property objc_property_t

 */
+ (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property
{
    @synchronized(self){
        char * type = property_copyAttributeValue(property, "T");
        
        switch(type[0]) {
            case 'f' : //float
            case 'd' : //double
            {
                return DBFloat;
            }
                break;
                
            case 'c':   // char
            case 's' : //short
            case 'i':   // int
            case 'l':   // long
            {
                return DBInt;
            }
                break;
                
            case '*':   // char *
                break;
                
            case '@' : //ObjC object
                //Handle different clases in here
            {
                NSString *cls = [NSString stringWithUTF8String:type];
                cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
                cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                    return DBText;
                }
                
                if ([NSClassFromString(cls) isSubclassOfClass:[NSData class]]) {
                    return DBData;
                }
                
               
            }
                break;
        }
        
        return DBText;
    }
}



+ (NSString *)dbNameConvertFromObjc_property_t:(objc_property_t)property
{
    @synchronized(self){
        NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        char * type = property_copyAttributeValue(property, "T");
        
        switch(type[0]) {
            case '@' : //ObjC object
                //Handle different clases in here
            {
                NSString *cls = [NSString stringWithUTF8String:type];
                cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
                cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
//                if ([NSClassFromString(cls) isSubclassOfClass:[STDbObject class]]) {
//                    //                NSString *retKey = [DBParentPrefix stringByAppendingString:key];
//                    NSString *retKey = key;
//                    return retKey;
//                }
            }
                break;
        }
        
        return key;
    }
}



@end
