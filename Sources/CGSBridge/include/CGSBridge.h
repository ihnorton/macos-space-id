#pragma once
#include <CoreGraphics/CoreGraphics.h>

typedef int CGSConnectionID;

/// Returns the CGS connection ID for the current process.
CGSConnectionID CGSMainConnectionID(void);

/// Returns an array of dictionaries describing all displays and their spaces.
/// Each top-level dict contains:
///   "Display Identifier" : String  (display UUID)
///   "Current Space"      : Dict    ("id64": Int, "type": Int, "uuid": String)
///   "Spaces"             : Array   of dicts with same keys plus "ManagedSpaceID"
CF_RETURNS_RETAINED CFArrayRef CGSCopyManagedDisplaySpaces(CGSConnectionID conn);
