# Xinshou


#import <Foundation/Foundation.h>
#import "LiaoMenu.h"
int main(int argc, const char * argv[]) {
    //添加联系人
    //删除联系人
    //修改联系人
    //查找联系人
    //显示所有联系人
    //退出
    @autoreleasepool {
        LiaoMenu *menu=[[LiaoMenu alloc]init];//创建菜单对象
        while (1) {
            [menu show];//显示菜单
            if([menu input])//等待输入并处理
            {
                break;
            }
        }
    }
    return 0;
}


LiaoMenu.h



#import <Foundation/Foundation.h>
#import "LiaoTeibook.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiaoMenu : NSObject
@property (strong,nonatomic) NSArray *items;
@property (strong,nonatomic) LiaoTeibook *book;
-(void)show;
-(BOOL)input;
@end

NS_ASSUME_NONNULL_END



LiaoMenu.m

#import "LiaoMenu.h"

@implementation LiaoMenu
@synthesize items;
-(instancetype)init
{
    self=[super init];
    if(self){
        self.items=[NSArray arrayWithObjects:@"添加一个联系人",@"删除一个联系人",@"修改一个联系人",@"查找联系人",@"显示所有联系人",@"退出系统", nil];
        self.book=[[LiaoTeibook alloc] init];
    }
    return self;
}

-(void)show
{
    int c=0;
    for(NSString *str in items)
    {
        c++;
        printf("%d、%s\n",c,[str UTF8String]);
    }
}

-(BOOL)input
{
    char ch[2];
    printf("请选择:(1-6)");
    scanf("%s",ch);
    ch[1]='\0';
    if(strcmp(ch,"1")==0)
    {
        if([self.book add])
        {
            printf("联系人添加成功！\n");
        }
        else
        {
            printf("联系人添加失败！\n");
            
        }
    }else if (strcmp(ch, "2")==0)
    {
        if([self.book delete])
        {
            printf("联系人删除成功！\n");
        }
        else
        {
            printf("联系人删除失败！\n");
        }
    }
    else if (strcmp(ch, "3")==0)
    {
        if([self.book update])
        {
            printf("联系人修改成功！\n");
        }
        else
        {
            printf("联系人修改失败！\n");
        }
    }
    else if (strcmp(ch, "4")==0)
    {
        if([self.book find])
        {
            printf("联系人查找成功！\n");
        }
        else
        {
            printf("联系人查找失败！\n");
        }
    }
    else if (strcmp(ch, "5")==0)
    {
        [self.book show];
    }
    else if (strcmp(ch, "6")==0)
    {
        return YES;
    }else
    {
        printf("非法的选择!\n");
    }
    return NO;
}



@end


LiaoTeibook.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiaoTeibook : NSObject
@property (strong,nonatomic) NSMutableArray * persons;
-(BOOL)add;
-(BOOL)delete;
-(BOOL)update;
-(BOOL)find;
-(void)show;
@end

NS_ASSUME_NONNULL_END



LiaoTeibook.m


#import "LiaoTeibook.h"
#import "LiaoPerson.h"
@implementation LiaoTeibook
-(instancetype)init
{
    self=[super init];
    if(self){
        //从文件中读取联系人
        self.persons=[NSKeyedUnarchiver
                      unarchiveObjectWithFile:@"persons.data"];
        if(self.persons==nil)//如果读取失败（没有这个文件）
        {
            //创建集合对象
            self.persons=[NSMutableArray arrayWithCapacity:100];
        }
    }
    return self;
}
-(BOOL)add
{
    //printf("你要添加一个联系人!\n");
    //得到联系人的姓名和电话
    char ch[20];
    LiaoPerson * person=[[LiaoPerson alloc]init];
    perror("请输入联系人的姓名:");
    scanf("%s",ch);
    ch[19]='\0';
    person.name=[NSString stringWithUTF8String:ch];
    perror("请输入联系人的电话:");
    scanf("%s",ch);
    ch[19]='\0';
    person.tel=[NSString stringWithUTF8String:ch];
    //对输入的数据进行校验
    //加到通讯录
    [self.persons addObject:person];
    //持久化
    [NSKeyedArchiver archiveRootObject:self.persons toFile:@"persons.data"];
    return YES;
}
-(BOOL)delete
{
    //printf("你要删除一个联系人!\n");
    //先得到你想删除的联系人
    char ch[4];
    printf("请输入你想删除联系人的编号：");
    scanf("%s",ch);
    ch[3]='\0';
    int n=atoi(ch);
    //输入数据的校验
    if(n>self.persons.count)
    {
        printf("无法删除的编号！\n");
        return NO;
    }
    //删除内存中的联系人
    [self.persons removeObjectAtIndex:n-1];
    //同步到磁盘
    [NSKeyedArchiver archiveRootObject:self.persons toFile:@"persons.data"];
    return YES;
}
-(BOOL)update
{
    //先得到我们想修改的联系人
    char ch[4];
    printf("请输入你想修改联系人的编号：");
    scanf("%s",ch);
    ch[3]='\0';
    int n=atoi(ch);
    if(n<=0 || n>self.persons.count)
    {
        printf("无法修改的编号！\n");
        return NO;
    }
    char chh[20];
    printf("请输入这个人的姓名：");
    scanf("%s",chh);
    chh[19]='\0';
    LiaoPerson * person=[[LiaoPerson alloc]init];
    person.name=[NSString stringWithUTF8String:chh];
    printf("请输入这个人的电话：");
    scanf("%s",chh);
    chh[19]='\0';
    person.tel=[NSString stringWithUTF8String:chh];
    //数据有效性检验
    
    //修改内存的联系人
    self.persons[n-1]=person;
    //同步到磁盘
    [NSKeyedArchiver archiveRootObject:self.persons toFile:@"persons.data"];
    //printf("你要修改一个联系人!\n");
    return YES;
}
-(BOOL)find
{
    //先得到你想查找的内容
    char ch[20];
    printf("请输入你想要查找的姓名或电话：");
    scanf("%s",ch);
    ch[19]='\0';
    NSString * str=[NSString stringWithUTF8String:ch];
    //到内存中去查找
    BOOL bz=NO;
    for(LiaoPerson * p in self.persons)
    {
        if ([p.name isEqualToString:str] || [p.tel isEqualToString:str])
        {
            printf("%s\t%s\n",[p.name UTF8String],[p.tel UTF8String]);
            bz=YES;
        }
    }
    //printf("你要查找联系人!\n");
    return bz;
}
-(void)show
{
    if(self.persons.count==0)
    {
        printf("对不起，目前还没有联系人！\n");
    }
    else
    {
        int c=0;
        printf("编号\t姓名\t电话\n");
        for(LiaoPerson * p in self.persons)
        {
            printf("%d\t%s\t%s\n",++c,[p.name UTF8String],[p.tel UTF8String]);
        }
    }
}
@end



LiaoPerson.h


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiaoPerson : NSObject<NSCoding>
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * tel;
@end

NS_ASSUME_NONNULL_END


LiaoPerson.m


#import "LiaoPerson.h"

@implementation LiaoPerson
@synthesize name,tel;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"NAME"];
    [aCoder encodeObject:tel forKey:@"TEL"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
    self.name=[aDecoder decodeObjectForKey:@"NAME"];
    self.tel=[aDecoder decodeObjectForKey:@"TEL"];
    }
    return self;
}
@end
