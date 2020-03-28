//
//  ApiListListener.h
//  MobileSDK
//
//  Created by Nathan Phillips on 27/11/18.
//  Copyright © 2018 Moneysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiListener.h"

/**
This class is an asynchronous handler for an API request which returns a list of objects as its "success" result.
*/
@interface ApiListListener<T: id>: ApiListener<NSArray*>

@end
