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
This class is an asynchronous handler for an API request which returns a list of objects as it's "success" result.  When using this, the result will need to be cast back the to an array of type `T` as NSArray stores objects without types.
*/
@interface ApiListListener<T: id>: ApiListener<NSArray*>

@end
