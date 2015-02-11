//
//  WebOperationQueue.m

//

#import "WebOperationQueue.h"
#import "SynthesizeSingleton.h"

@implementation WebOperationQueue
#pragma mark - Class Methods
+ (WebOperationQueue *)sharedWebOperationQueue {
    DEFINE_SHARED_INSTANCE_USING_BLOCK ( ^{
                                             return [[self alloc] init];
                                         }

                                         )
}

#pragma mark -
- (id)init {
    if (self = [super init]) {
        [self setMaxConcurrentOperationCount:1];
    }

    return self;
}

@end
