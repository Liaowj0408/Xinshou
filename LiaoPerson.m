//
//  LiaoPerson.m
//  廖万军的通讯录
//
//  Created by student on 2019/6/24.
//  Copyright © 2019年 student. All rights reserved.
//

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
