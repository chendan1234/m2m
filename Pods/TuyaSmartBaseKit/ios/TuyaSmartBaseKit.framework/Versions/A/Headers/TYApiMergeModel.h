//
// TYApiMergeModel.h
// TuyaSmartBaseKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TYApiMergeModel_h
#define TYApiMergeModel_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief TYApiMergeModel is an object of response data from TYApiMergeService.
@interface TYApiMergeModel : NSObject

/// Indicates a successful call.
@property (nonatomic, assign) BOOL      success;

/// The name of the API operation.
@property (nonatomic, strong) NSString  *apiName;

/// An error occurs while processing the request.
@property (nonatomic, strong) NSError   *error;

/// The response result.
@property (nonatomic, strong) id        result;

/// The timestamp.
@property (nonatomic, assign) NSTimeInterval time;

@end

NS_ASSUME_NONNULL_END

#endif /* TYApiMergeModel_h */
