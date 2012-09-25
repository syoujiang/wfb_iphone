//
//  ySingletonImpTemple.h
//
//  yLib
//
//  Created by Peter Liu on 8/20/11.
//  Copyright 2011 www.yeahren.com. All rights reserved.
//

#ifndef SINGLETON_IMP_TEMPLE_H
#define SINGLETON_IMP_TEMPLE_H

#define YLIB_SINGLETON_DEFINE_TEMPLE(CLASSNAME) \
+ (CLASSNAME *)shared##CLASSNAME; \

#define YLIB_SINGLETON_IMP_TEMPLE(CLASSNAME) \
static CLASSNAME *gShared##CLASSNAME = nil;\
+ (void)initialize\
{\
    if(self == [CLASSNAME class])\
        gShared##CLASSNAME = [[self alloc] init];\
}\
\
+ (CLASSNAME*)shared##CLASSNAME \
{\
    return gShared##CLASSNAME;\
}\
\
- (id)retain\
{\
return self;\
}\
\
- (NSUInteger)retainCount\
{\
return NSUIntegerMax;\
}\
\
- (oneway void)release\
{\
\
}\
- (id)autorelease\
{\
return self;\
}

#endif


