const std = @import("std");
const Keccak256 = std.crypto.hash.sha3.Keccak256;
const Interpreter = @import("../../Interpreter.zig");
const utils = @import("utils");
const Word = @import("eth_types").Word;

pub inline fn codesize(interp: *Interpreter) !void {
    const code = interp.frames.top().?.executing_contract.code;
    try interp.stack.push(code.len);
}

pub inline fn extcodesize(interp: *Interpreter) !void {
    const address = interp.stack.pop();
    const contract_code = interp.host.getContractCode(@truncate(address)).?;
    try interp.stack.push(contract_code.len);
}

// TODO: do this without branching
pub inline fn codecopy(interp: *Interpreter) !void {
    const code = interp.frames.top().?.executing_contract.code;
    try copyToMemory(interp, code);
}

pub inline fn extcodecopy(interp: *Interpreter) !void {
    const address = interp.stack.pop();
    const bytecode = interp.host.getContractCode(@truncate(address)).?;
    try copyToMemory(interp, bytecode);
}

pub inline fn extcodehash(interp: *Interpreter) !void {
    const address = interp.stack.pop();
    const contract_code = interp.host.getContractCode(@truncate(address)).?;

    var hash: [32]u8 = undefined;
    Keccak256.hash(contract_code, &hash, .{});
    try interp.stack.push(utils.intFromBigEndianBytes(Word, &hash));
}

pub inline fn callvalue(interp: *Interpreter) !void {
    const frame = interp.frames.top().?;
    try interp.stack.push(frame.call_value);
}

pub inline fn calldatasize(interp: *Interpreter) !void {
    const frame = interp.frames.top().?;
    try interp.stack.push(frame.call_data.len);
}

pub inline fn calldatacopy(interp: *Interpreter) !void {
    const frame = interp.frames.top().?;
    try copyToMemory(interp, frame.call_data);
}

pub inline fn calldataload(interp: *Interpreter) !void {
    const offset: usize = @intCast(interp.stack.pop());

    const frame = interp.frames.top().?;
    var bytes: [@sizeOf(Word)]u8 = .{0} ** @sizeOf(Word);

    const end = @min(offset + @sizeOf(Word), frame.call_data.len);
    for (offset..end) |call_data_index| {
        const index = call_data_index - offset;
        bytes[index] = frame.call_data[call_data_index];
    }

    try interp.stack.push(utils.intFromBigEndianBytes(Word, &bytes));
}

// TODO: move this to Memory.zig
fn copyToMemory(interp: *Interpreter, bytes: []const u8) !void {
    const dest_offset = interp.stack.pop();
    const offset = interp.stack.pop();
    const size: usize = @intCast(interp.stack.pop());

    for (0..size) |index| {
        const memoryIndex: usize = @truncate(dest_offset + index);
        const bytesIndex: usize = @truncate(offset + index);
        if (bytesIndex < bytes.len) {
            try interp.memory.store8(bytes[bytesIndex], memoryIndex);
        } else {
            try interp.memory.store8(0x00, memoryIndex);
        }
    }

}
