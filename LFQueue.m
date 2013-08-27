#import "LFQueue.h"

static NSUInteger sQueueMax = 0;

@implementation LFQueue

+ (LFQueue*)queueWithMaxCount:(NSUInteger)max
{
    sQueueMax = max;
    LFQueue *q = [[LFQueue alloc] initWithCapacity:sQueueMax];
    return [q autorelease];
}

- (void)enqueue:(id)t
{
    [self addObject:t];
}

- (void)deque:(id)t
{
    [self removeObject:t];
}

- (id)initWithCapacity:(NSUInteger)max
{
    if (self = [super init]) {
        waittings = [[NSMutableSet set] retain];
        doings  = [[NSMutableSet setWithCapacity:sQueueMax] retain];
    }
    return self;
}
- (NSUInteger)count
{
    return [doings count];
}
-(void)dealloc
{
    [waittings release];
    [doings release];
    [super dealloc];
}

- (void)addObject:(id)anObject
{
    if ([doings containsObject:anObject]) {
        return;
    }
    if ([self count] >= sQueueMax) {
        [waittings addObject:anObject];
        return;
    }
    [doings addObject:anObject];
    [anObject resume];
    return;
}

- (void)removeObject:(id)anObject
{
    [doings removeObject:anObject];
    
    if ([waittings count] > 0) {
        id t = [waittings anyObject];
        if ([self count] < sQueueMax) {
            [doings addObject:t];
            [t resume];
        }
        [waittings removeObject:t];
    }
}

@end


