const std = @import("std");
const data = @import("data/entries.zig");

const Allocator = std.mem.Allocator;
const StringArray = std.ArrayListUnmanaged([]const u8);

const Person = struct {
  allocator: Allocator,

  first_name: []const u8,
  last_name: []const u8,
  organization: []const u8,

  emails: StringArray,
  phones: StringArray,

  fn init(allocator: Allocator) !Person {
    var self: Person = undefined ;

    // Assigns allocator required to move unknown email and phone array sizes to the heap.
    self.allocator = allocator;

    // Pick a few details for this person.
    self.first_name = pick_random(&data.names.first_names);
    self.last_name = pick_random(&data.names.last_names);
    self.organization = pick_random(&data.organizations.items);

    self.emails = StringArray{};
    for (0..3) |_| {
      try self.emails.append(allocator, pick_random(&data.emails.items));
    }

    self.phones = StringArray{};
    for (0..3) |_| {
      try self.phones.append(allocator, pick_random(&data.phones.items));
    }

    return self;
  }

  fn deinit(self: *Person) void {
    self.emails.deinit(self.allocator);
    self.phones.deinit(self.allocator);
  }

  fn debug(self: *const Person) void {
    std.debug.print("\n", .{});
    std.debug.print("Name: {s} {s}\n", .{ self.first_name, self.last_name });
    std.debug.print("Company: {s}\n", .{ self.organization });

    std.debug.print("Emails: \n", .{});
    for (self.emails.items, 0..) |value, index| {
      std.debug.print("{d}: {s}\n", .{ index, value });
    }

    std.debug.print("Phones: \n", .{});
    for (self.phones.items, 0..) |value, index| {
      std.debug.print("{d}: {s}\n", .{ index, value });
    }
  }
};

fn pick_random(items: []const []const u8) []const u8 {
  const rand = std.crypto.random;
  const last_index = items.len - 1;
  const index = rand.intRangeAtMost(usize, 0, last_index);
  const random_item = items[index];

  return random_item;
}

test "person data fields are present" {
  const allocator = std.testing.allocator;

  // Instantiates a person, requires called to free.
  var person = try Person.init(allocator);
  defer person.deinit();

  // Checks for expected data:
  try std.testing.expect(person.first_name.len > 0);
  try std.testing.expect(person.last_name.len > 0);
  try std.testing.expect(person.organization.len > 0);
  try std.testing.expect(person.emails.items.len > 0);
  try std.testing.expect(person.phones.items.len > 0);
}
