/// This file exposes all data sets through a single module.
/// This access so that it can be used as follows:
///
/// const data = @import("data/entries.zig");
/// const emails = data.emails.items;
///
pub const names = @import("names.zig");
pub const emails = @import("emails.zig");
pub const phones = @import("phones.zig");
pub const domains = @import("domains.zig");
pub const organizations = @import("organizations.zig");
