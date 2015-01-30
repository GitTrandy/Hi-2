
#import "NSObject+DBCatefgory.h"
@implementation NSObject (DBCatefgory)


///A.插入
+(void)insertModelToDB:(id)model
             condition:(NSString*)condition
            didInsertBlock:(DBCatefgoryDidInsertBlock)block{
    
    [self queryFormDB:condition orderBy:nil count:5 success:^(id results) {
        if (!results) {
            [self insertToDB:model];
            if (block) {
                //当插入后需要更新
                block();
            }
        }else{
            if (block) {
                //当插入后需要更新
                block();
            }
        
        }
    }];
}

///B.查询

+(NSMutableArray*)queryFormDB:(NSString*)Where
           orderBy:(NSString*)order
             count:(NSInteger)count
           success:(DBCatefgoryArrayBlock)success{

    BOOL isExist = [[self getUsingLKDBHelper] isExistsWithTableName:NSStringFromClass([self class]) where:nil];
    if (!isExist) {
        if (success) {
            success(nil);
        }
        return nil;

    }else{
        
        NSMutableArray*msgArray=[self searchWithWhere:Where orderBy:order offset:0 count:count];
        if (!msgArray||msgArray.count<=0) {
            if (success) {
                success(nil);
            }
            return nil;
        }else{
            if (success) {
                success(msgArray);
            }
            return msgArray;
            
        }
    }
}





+(NSMutableArray*)queryFormDBComplexSQL:(NSString *)ComplexSQL{

    BOOL isExist = [[self getUsingLKDBHelper] isExistsWithTableName:NSStringFromClass([self class]) where:nil];
    if (!isExist) {
        
        return nil;
    }else{
        
        NSMutableArray*msgArray=[[self getUsingLKDBHelper]searchWithSQL:ComplexSQL toClass:[self class]];
        if (!msgArray||msgArray.count<=0) {
            return nil;
        }else{
            return msgArray;
        }
    }
}


///C.更新
+ (BOOL)updatePropertyName:(NSString*)propertyName
               newProperty:(id)newProperty
                     where:(NSString*)where{

    BOOL isExist = [[self getUsingLKDBHelper] isExistsWithTableName:NSStringFromClass([self class]) where:nil];
    if (!isExist) {
        return NO;
    }else{
        
        __block BOOL isSuccess=NO;
        NSString * updateSql=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' where %@ ",NSStringFromClass([self class]),propertyName,newProperty,where];
        [[self getUsingLKDBHelper]executeDB:^(FMDatabase *db) {
            isSuccess= [db executeUpdate:updateSql];
        }];
        
        return isSuccess;
    }
}

@end

