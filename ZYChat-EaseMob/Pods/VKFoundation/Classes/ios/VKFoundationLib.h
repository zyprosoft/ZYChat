//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#define NILIFNULL(foo) ((foo == [NSNull null]) ? nil : foo)
#define NULLIFNIL(foo) ((foo == nil) ? [NSNull null] : foo)
#define EMPTYIFNIL(foo) ((foo == nil) ? @"" : foo)

#define CGRectSetOrigin( r, origin ) CGRectMake( origin.x, origin.y, r.size.width, r.size.height )

typedef void (^VoidBlock)();
