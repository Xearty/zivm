const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

const evm = @import("evm");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var evm_context = evm.Context.init(allocator);
    defer evm_context.deinit();

    const bytecode: []const u8 = &.{
        @intFromEnum(evm.Opcode.PUSH1), 0x5,
        @intFromEnum(evm.Opcode.DUP1),
        @intFromEnum(evm.Opcode.MUL),
    };
    try evm.executeBytecode(&evm_context, bytecode);

    print("{}\n", .{evm_context});
}
