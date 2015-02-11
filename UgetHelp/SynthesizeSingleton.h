//
//  SynthesizeSingleton.h
//  CocoaWithLove
//

//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

// for ARC
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
    static dispatch_once_t pred = 0;              \
    __strong static id _sharedObject = nil;       \
    dispatch_once(&pred, ^{                       \
                      _sharedObject = block();    \
                  }                               \
                  );                              \
    return _sharedObject;                         \


// non-ARC below by CocoaWithLove

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname)                 \
                                                                  \
    static classname * shared ## classname = nil;                 \
                                                                  \
    + (classname *)shared ## classname                            \
    {                                                             \
        @synchronized(self)                                       \
        {                                                         \
            if (shared ## classname == nil)                       \
            {                                                     \
                shared ## classname = [[self alloc] init];        \
            }                                                     \
        }                                                         \
                                                                  \
        return shared ## classname;                               \
    }                                                             \
                                                                  \
    + (id)allocWithZone:(NSZone *)zone                            \
    {                                                             \
        @synchronized(self)                                       \
        {                                                         \
            if (shared ## classname == nil)                       \
            {                                                     \
                shared ## classname = [super allocWithZone:zone]; \
                return shared ## classname;                       \
            }                                                     \
        }                                                         \
                                                                  \
        return nil;                                               \
    }                                                             \
                                                                  \
    - (id)copyWithZone:(NSZone *)zone                             \
    {                                                             \
        return self;                                              \
    }                                                             \
                                                                  \
    - (id)retain                                                  \
    {                                                             \
        return self;                                              \
    }                                                             \
                                                                  \
    - (NSUInteger)retainCount                                     \
    {                                                             \
        return NSUIntegerMax;                                     \
    }                                                             \
                                                                  \
    - (oneway void)release                                        \
    {                                                             \
    }                                                             \
                                                                  \
    - (id)autorelease                                             \
    {                                                             \
        return self;                                              \
    }
