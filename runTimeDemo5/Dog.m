//
//  Dog.m
//  runTimeDemo5
//
//  Created by yangL on 16/3/26.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "Dog.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DogOther.h"

@implementation Dog

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dogOther = [DogOther new];
    }
    return self;
}

- (void)bark {
    NSLog(@"Dog bark!");
}

/*消息的转发流程
  1、（动态添加方法）接收到未知消息时：（main中调用的says方法在Dog类及其父类中没有实现）runtime会调用: (实例方法)+ (BOOL)resolveInstanceMethod:(SEL)sel 或者 (类方法)+ (BOOL)resolveClassMethod:(SEL)sel;
  2、（备用接收者-->消息分发）如果1没有做任何处理，那么runtime就会调用 - (id)forwardingTargetForSelector:(SEL)aSelector; 
      返回值满足的条件 : 1.非nil 2.非self 3.必须返回一个实现了该方法的对象（例如返回对象dogOther，让dogOther实现says方法，这样消息就能被成功的转发出去，被dogOther对象接受，并输出结果）
  3、（完整的消息转发）- (void)forwardInvocation:(NSInvocation *)anInvocation 中选择转发消息的对象，anInvocation封装了未知消息的所有细节； 注意必须重写methodSignatureForSelector才能走到forwardInvocation方法；
*/

////1、类方法调用最终找不到 会走这个方法
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    
//    return [super resolveClassMethod:sel];
//}
//
////对象调用最终找不到 会走这个方法 我们可以在该方法中实现对应的处理逻辑
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSString *selStr = NSStringFromSelector(sel);//获取方法名
//    if ([selStr isEqualToString:@"says"]) {
//        //动态添加方法
//        class_addMethod([self class], @selector(says), (IMP)notFoundSaysMethod, "@:");
//    }
//    
//    return [super resolveInstanceMethod:sel];
//}
//
//void notFoundSaysMethod(id self, SEL _cmd) {
//    printf("notFoundSaysMethod\n");
//}

////2、备用的接收者--->消息转发
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSString *selStr = NSStringFromSelector(aSelector);
//    if ([selStr isEqualToString:@"says"]) {
//        return self.dogOther;
//    }
//    
//    return [super forwardingTargetForSelector:aSelector];
//}

//3、完整消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([DogOther instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.dogOther];
    } else {
        [super forwardInvocation:anInvocation];
    }
        
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        if ([DogOther instancesRespondToSelector:aSelector]) {
            signature = [DogOther instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

@end
