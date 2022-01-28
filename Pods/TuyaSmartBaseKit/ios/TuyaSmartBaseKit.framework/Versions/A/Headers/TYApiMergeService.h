//
// TYApiMergeService.h
// TuyaSmartBaseKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TYApiMergeService_h
#define TYApiMergeService_h

#import "TYApiMergeModel.h"
#import "TuyaSmartRequest.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief TYApiMergeService is used for making several requests in one HTTP request.
///
/// This class is used for reduce the number of network requests. Use it with the following steps:
///     1. Create a TYApiMergeService instance
///     2. Add several request by `-[TYApiMergeService addApiRequest:postData:version:]`
///     3. SendRequests by `- [TYApiMergeService sendRequest:success:failure]`. requests will be sent and received together.
///
/// @discussion Due to HTTP/2 multiplexing technology, it is not recommend for use now.
///
@interface TYApiMergeService : TuyaSmartRequest

@property (nonatomic, strong) TYSDKSafeMutableArray *requestList;


/// Adds an API request.
/// @param apiName The name of the API operation.
/// @param postData The Post data.
/// @param version The version.
- (void)addApiRequest:(NSString *)apiName postData:(NSDictionary *)postData version:(NSString *)version;


/// Sends a request.
/// @param getData Returns data.
/// @param success Called when the task is finished. A list of TYApiMergeModel is returned.
/// @param failure Called when the task is interrupted by an error.
- (void)sendRequest:(NSDictionary *)getData success:(nullable void (^)(NSArray <TYApiMergeModel *> *list))success failure:(nullable TYFailureError)failure;

@end

NS_ASSUME_NONNULL_END

#endif /* TYApiMergeService_h */
