//
//  WMHTTPResult.h
//
//

#import <Foundation/Foundation.h>

@interface WMHTTPResult : NSObject

typedef NS_ENUM(NSInteger, WMHTTPErrorCode) {
    
    /**
     * 未知错误。
     */
    WMHTTPCodeUNKNOWN = -1,// "unknown"
    
//    /**
//     * result code for common usage
//     */
    //TODO
    WMHTTPCodeSuccess = 0,
//    RCEHTTPCodeNotPermitted = 10001,
//    RCEHTTPCodeNotSupport = 10002,
//    RCEHTTPCodefailure = 10003,
//    RCEHTTPCodeNotImplement = 10004,
//    RCEHTTPCodeRongServerFailure = 10005,
//    IRCEHTTPCodeInvalid = 10006,
//    RCEHTTPCodeNotModified = 10007,
//    
//    
//    /**
//     * result code for user service
//     */
//    RCEHTTPCodeUserNotFound = 10100,
//    RCEHTTPCodeUserNameAndPasswordNotMatch = 10101,
//    RCEHTTPCodeInauthorized = 10102,
//    RCEHTTPCodePasswordFormatError = 10103,
//    RCEHTTPCodeNickNameIsEmpty = 10104,
//    RCEHTTPCodeNickNameTooLong = 10105,
//    RCEHTTPCodePortraitUrlIsEmpty = 10106,
//    RCEHTTPCodePortraitUrlTooLong = 10107,
//    RCEHTTPCodeNotLogin = 10108,
//    RCEHTTPCodeEmptyUserName = 10109,
//    RCEHTTPCodeEmptyPassword = 10110,
//    RCEHTTPCodeUserForbidden = 10111,
//    RCEHTTPCodeGetIMTokenFailure = 10112,
//    RCEHTTPCodeUserIdIsEmpty = 10113,
//    RCEHTTPCodePasswordIsEmpty = 10114,
//    RCEHTTPCodeInvalidPhoneNumber = 10115,
//    RCEHTTPCodeSendCodeOverFrenquency = 10116,
//    RCEHTTPCodeVerifyCodeOverTime = 10117,
//    RCEHTTPCodeNotSendCodeYet = 10118,
//    RCEHTTPCodeNotVerifyCodeYet = 10119, 
//    RCEHTTPCodeVerifyCodeError = 10120,
//    RCEHTTPCodeUserExist = 10121,
//    RCEHTTPCodeUserBlockedByAdmin = 10122,
//    RCEHTTPCodeOldPasswordInvalid = 10126,
//    RCEHTTPCodeNameInvalidFormat = 10127,
//    RCEHTTPCodeAccountIsLocked = 10128,
//    
//    /**
//     * result code for EAB(Enterprise Address Book) service
//     */
//    RCEHTTPCodeDepartmentNotFound = 10200,
//    RCEHTTPCodeDepartmentNameIsEmpty = 10201,
//    RCEHTTPCodeInvalidDepartmentId = 10202,
//    RCEHTTPCodeParentDepartmentNotFound = 10203,
//    RCEHTTPCodeInvalidCreatorId = 10204,
//    RCEHTTPCodeCreatorNotFound = 10205,
//    RCEHTTPCodeInvalidManagerId = 10206,
//    RCEHTTPCodeManagerNotFound = 10207,
//    RCEHTTPCodeInvalidDepartMemberId = 10208,
//    RCEHTTPCodeDepartMemberNotFound = 10209,
//    RCEHTTPCodeDepartExistedUId = 10210,
//    
//    /**
//     * result code for contact service
//     */
//    RCEHTTPCodeContactNotFound = 10400,
//    RCEHTTPCodeContactInvalidId = 10401,
//    
//    /**
//     * result code for staff service
//     */
//    RCEHTTPCodeStaffNotFound = 10500,
//    RCEHTTPCodeUserNameEmpty = 10501,
//    RCEHTTPCodeUserNameExisted = 10502,
//    RCEHTTPCodeEmallExisted = 10503,
//    RCEHTTPCodeStaffEmallExisted = 10504,
//    RCEHTTPCodeInvalidId = 10505,
//    RCEHTTPCodeExistedUId = 10506,
//    RCEHTTPCodeSupervisorNotFound = 10507,
//    RCEHTTPCodeMobileCanNotBeEmpty = 10508,
//    RCEHTTPCodeMobileExisted = 10509,
//    RCEHTTPCodeInvalidUID = 10510,
//    RCEHTTPCodeStaffIsDeleted = 10511,
//    
//    /**
//     * result code for group service
//     */
//    RCEHTTPCodeGroupNotFound = 10600,
//    RCEHTTPCodeGroupNameIsEmpty = 10601,
//    RCEHTTPCodeGroupNameTooLong = 10602,
//    RCEHTTPCodeMemberUpToMaximum = 10603,
//    RCEHTTPCodeGroupNumberUpToMaximum = 10604,
//    RCEHTTPCodeGroupMemberNotFound = 10605,
//    RCEHTTPCodeGroupMemberExisted = 10606,
//    RCEHTTPCodeInvalidGroupId = 10607,
//    RCEHTTPCodeInvalidGroupMemberId = 10608,
//    RCEHTTPCodeMappingDepartNotFound = 10609,
//    RCEHTTPCodeInvalidMappingDepartId = 10610,
//    RCEHTTPCodeLackOfGroupType = 10611,
//    RCEHTTPCodeGroupUIdExisted = 10612,
//    RCEHTTPCodeOfficialGroupExisted = 10613,
//    RCEHTTPCodeMappingCompanyNotFound = 10614,
//    RCEHTTPCodeInvalidMappingCompanyId = 10615,
//    RCEHTTPCodeGroupNoticeHasNoPermission = 10626,
//    RCEHTTPCodeGroupNoticeNotFound = 10639,
//    RCEHTTPCodeGroupHasDeleted = 10641,
//    
//    
//    /**
//     * result code for company
//     */
//    RCEHTTPCodeCompanyNotFound = 10700,
//    RCEHTTPCodeInvalidCompanyId = 10701,
//    RCEHTTPCodeExistedConpanyUId = 10702,
//    RCEHTTPCodeEmptyCompanyName = 10703,
//    RCEHTTPCodeEmptyCompanyFullname = 10704,
//    RCEHTTPCodeEmptyCompanyGroupName = 10705,
//    RCEHTTPCodeExistedOfficialGroup = 10706,
//    RCEHTTPCodeNoOfficialGroup = 10707,
//    
//    /**
//     * result code for favorite group service
//     */
//    RCEHTTPCodeInvalidFavoriteGroupId = 10800,
//    RCEHTTPCodeMappingGroupNotFound = 10801,
//    RCEHTTPCodeFavoriteGroupNotExisted = 10802,
//    
//    /**
//     * result code for favorite contact service
//     */
//    RCEHTTPCodeMappingStaffNotFound = 10900,
//    RCEHTTPCodeFavoriteContactNotExisted = 10901,
//    
//    /**
//     * result code for user setting service
//     */
//    RCEHTTPCodeNotFoundScope = 11000,
//    RCEHTTPCodeNotFoundName = 11001,
//    
//    /**
//     * result code for presence service
//     */
//    RCEHTTPCodeInvalidTopic = 12000,
//    
//    
//    /**
//     * result code for QRCode
//     */
//    RCEHTTPCodeLoginTokenTimeout = 10122,
//    RCEHTTPCodeLoginTokenInvalid = 10123,
//    RCEHTTPCodeLoginTokenPolling = 10124,
//    
//    /**
//     * result code for conference call
//     */
//    RCEHTTPCodeNoParticipant = 11500,
//    RCEHTTPCodeGroupNotExist = 11501,
//    RCEHTTPCodeMemberBusy = 11502,
//    RCEHTTPCodeConferenceNotExist = 11503,
//    RCEHTTPCodeOperationNotAllowed = 11504,
//    RCEHTTPCodeOperationNotExist = 11505,
//    RCEHTTPCodeMemberNotInGroup = 11506,
//    RCEHTTPCodeRemoteError = 11507,
//    
//    /**
//     * result code for duty
//     */
//    RCEHTTPCodeDutyNotFound = 13000,
//    
//    RCEHTTPCodeArgumentError = 30000,
//    
//    RCEHTTPCodeNetworkError = 40000,
//    
//    /**
//     * result code for contact service, friend
//     */
//    RCEHTTPCodeCanNotAddYourself = 10400,
//    RCEHTTPCodeRequestNotExist = 10401,
//    RCEHTTPCodeFriendNotFound = 10402,
//    RCEHTTPCodeRequestIsTimeout = 10403,
//    RCEHTTPCodeFriendshipIsCreated = 10404,
//    
//    /**
//     * result code for pin service
//     */
//    RCEHTTPCodeGetPinDataFromDBError = 12000,
//    RCEHTTPCodeNotInReceiverList = 11400,
//    RCEHTTPCodeNotTheCreatorOfThePin = 11401,
//    RCEHTTPCodeNotConfirmed = 11402,
//    RCEHTTPCodePinNotExist = 11403,
//    RCEHTTPCodePinAlreadySent = 1404,
//    RCEHTTPCodePinNotSent = 11405,
    
    
    
};

//请求是否成功
@property(nonatomic, assign) BOOL success;

// http错误码
@property(nonatomic, assign) NSInteger httpCode;

//接口状态码，必选
@property(nonatomic, assign) NSInteger errorCode;

//接口结果描述，不一定返回
@property(nonatomic, strong) NSString *message;

// json，成功才返回
@property(nonatomic, strong) id content;

@end
