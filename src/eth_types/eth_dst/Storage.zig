const std = @import("std");
const AutoHashMap = std.AutoHashMap;
const Allocator = std.mem.Allocator;
const printBoxed = @import("evm_utils").printBoxed;
const Word = @import("../root.zig").Word;

const Self = @This();
const InnerType = AutoHashMap(Word, Word);

inner: InnerType,

pub fn init(allocator: Allocator) Self {
    return .{
        .inner = InnerType.init(allocator),
    };
}

pub fn deinit(self: *Self) void {
    self.inner.deinit();
}

pub fn store(self: *Self, key: Word, value: Word) !void {
    try self.inner.put(key, value);
}

pub fn load(self: *Self, key: Word) ?Word {
    return self.inner.get(key);
}

pub fn prettyPrint(self: *const Self) !void {
    var buffer: [1024]u8 = undefined;
    const format = "{} = {}";
    var message = std.ArrayList(u8).init(self.inner.allocator);
    defer message.deinit();

    var iter = self.inner.iterator();
    while (iter.next()) |pair| {
        const key = pair.key_ptr.*;
        const value = pair.value_ptr.*;
        const line = try std.fmt.bufPrint(&buffer, format, .{key, value});
        try message.appendSlice(line);
        try message.append('\n');
    }

    _ = message.popOrNull();
    printBoxed("Storage", message.items);
}
