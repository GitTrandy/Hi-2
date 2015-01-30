

//#ifdef DEBUG
//#define debugLog(...)    NSLog(__VA_ARGS__)
//#define debugMethod()    NSLog(@"%s", __func__)
//#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
//#else
//#define debugLog(...)
//#define debugMethod()
//#define debugError()
//#endif

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  沙盒的文件位置
 */
#define FILE_OF_DOCUMENT(FILENAME) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:FILENAME]

#define DEFAULT_DB_NAME  @"Meimei.sqilte"


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
typedef void(^FMDBToolQueryArraySuccess)(NSArray * queryResults);

@interface FMDBTool : NSObject
+(NSInteger)querySum:(NSString*)sql;

+(void)checkExistPropertyAndImport:(NSString*)key
                              type:(NSString*)type
                         className:(NSString*)className;
//判断是否存在表
+ (BOOL)tableExist:(Class)aClass;
///创建表
+(BOOL)CreateTableWithClass:(Class)className;

///删除表
+(BOOL)dropTable:(Class)className
           where:(NSString*)where;

#pragma mark -对象
//更新数据
+ (BOOL)updateDbObject:(Class)className
          propertyName:(NSString*)propertyName
           newProperty:(id)newProperty
                 where:(NSString*)where;

///插入,封装不太完善，一次性插入1000以上会用0.5s
+ (BOOL)insertDbObject:(NSObject*)obj;
///查询，,封装不太完善，一次性1000以上会用0.5s,where=@"WHERE myname='acc'" 最好加上查询数量,如:limitx=50
+(NSMutableArray*)queryClass:(Class)className
            where:(NSString*)where
          success:(FMDBToolQueryArraySuccess)success;


@end
