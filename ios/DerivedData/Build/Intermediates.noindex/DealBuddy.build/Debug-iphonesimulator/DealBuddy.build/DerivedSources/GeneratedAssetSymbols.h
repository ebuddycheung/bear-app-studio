#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.bearappstudio.dealbuddy";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "DealPlaceholder" asset catalog image resource.
static NSString * const ACImageNameDealPlaceholder AC_SWIFT_PRIVATE = @"DealPlaceholder";

/// The "EmptyDeals" asset catalog image resource.
static NSString * const ACImageNameEmptyDeals AC_SWIFT_PRIVATE = @"EmptyDeals";

/// The "EmptyFriends" asset catalog image resource.
static NSString * const ACImageNameEmptyFriends AC_SWIFT_PRIVATE = @"EmptyFriends";

/// The "Onboarding1" asset catalog image resource.
static NSString * const ACImageNameOnboarding1 AC_SWIFT_PRIVATE = @"Onboarding1";

/// The "Onboarding2" asset catalog image resource.
static NSString * const ACImageNameOnboarding2 AC_SWIFT_PRIVATE = @"Onboarding2";

/// The "Onboarding3" asset catalog image resource.
static NSString * const ACImageNameOnboarding3 AC_SWIFT_PRIVATE = @"Onboarding3";

/// The "PremiumBadge" asset catalog image resource.
static NSString * const ACImageNamePremiumBadge AC_SWIFT_PRIVATE = @"PremiumBadge";

#undef AC_SWIFT_PRIVATE
