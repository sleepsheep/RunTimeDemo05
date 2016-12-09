//
//  main.m
//  runTimeDemo5
//
//  Created by yangL on 16/3/26.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Dog.h"

/*!
 *  @author yangL, 16-03-26 16:03:07
 *  准备工作：
 *   #import <objc/runtime.h>
     #import <objc/message.h>
     在Build Settings 中设置 enable strict checking of objc_msgsend calls 为 no
     理解objc_class的结构体组成：
     struct objc_class {
     Class isa  OBJC_ISA_AVAILABILITY;
     
     #if !__OBJC2__
     Class super_class                                        OBJC2_UNAVAILABLE;
     const char *name                                         OBJC2_UNAVAILABLE;
     long version                                             OBJC2_UNAVAILABLE;
     long info                                                OBJC2_UNAVAILABLE;
     long instance_size                                       OBJC2_UNAVAILABLE;
     struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
     struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
     struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
     struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
     #endif
     
     } OBJC2_UNAVAILABLE;
 
 *  @brief 消息机制的运行原理 : 用[dog say] 为例来描述方法调用的流程
 *  1、首先编译器会把[dog say]转换为 objc_msgsend(dog, @selector(say)) 两者的效果相同
 *  2、Runtime会在dog对象对应的类Dog中的方法缓存中查找方法的SEL 即查找是否存在say方法（objc_cache）
 *  3、如果没有找到就会去Dog类的方法列表中查找say方法的SEL （通过类的isa指针指向的methodlist）
 *  4、如果没有找到，就会去Dog的父类Animal的方法列表中查找say方法的SEL （通过Dog类的super_class指向其父类）
 *  5、如果没有找到就继续在Animal的父类（NSObject）中查找，依次类推
 *  6、如果在缓存、本类或者父类中找到，则定位到方法的入口开始执行
 *  7、如果一直找到NSObject还是没有找到，那么就会根据以下两种情况进行处理：
 *     1、如果方法的调用时使用的是[dog say]----->那么编译器就会因为找到不到响应的方法而报错
 *     2、如果方法的调用时使用的是[dog performSelector:@selector(say)]------>就会进入消息的转发流程
 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Dog *dog = [[Dog alloc] init];
//        [dog say];   //等价于 objc_msgSend(dog, @selector(say));
//        [dog bark];
        
        //这种情况属于7中的第二种，进入消息的转发流程 参考 Dog类中的注释
        [dog performSelector:@selector(says)];//notFoundSaysMethod
        
        
        
    }
    return 0;
}
