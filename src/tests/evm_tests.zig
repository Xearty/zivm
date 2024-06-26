const Word = @import("types").Word;
const SignedWord = @import("types").SignedWord;
const testing_utils = @import("test_utils.zig");
const op = testing_utils.op;
const volatileStackTestValue = testing_utils.volatileStackTestValue;
const volatileStackTestError = testing_utils.volatileStackTestError;

test "ADD instruction" {
    try volatileStackTestValue(0x3, &.{
        op(.PUSH1), 0x1,
        op(.PUSH1), 0x2,
        op(.ADD),
    });
}

test "MUL instruction" {
    try volatileStackTestValue(0x25 * 0x53 * 0x31, &.{
        op(.PUSH1), 0x25,
        op(.PUSH1), 0x53,
        op(.MUL),
        op(.PUSH1), 0x31,
        op(.MUL),
    });
}

test "ADD and MUL instructions" {
    try volatileStackTestValue(0x9, &.{
        op(.PUSH1), 0x1,
        op(.PUSH1), 0x2,
        op(.ADD),
        op(.PUSH1), 0x3,
        op(.MUL),
    });
}

test "STOP instruction" {
    try volatileStackTestValue(0x3, &.{
        op(.PUSH1), 0x1,
        op(.PUSH1), 0x2,
        op(.ADD),
        op(.PUSH1), 0x3,
        op(.STOP),
        op(.MUL),
    });
}

test "SUB instruction" {
    try volatileStackTestValue(0x6, &.{
        op(.PUSH1), 0x1,
        op(.PUSH1), 0x2,
        op(.ADD),
        op(.PUSH1), 0x9,
        op(.SUB),
    });
}

test "DIV instruction" {
    try volatileStackTestValue(0x3, &.{
        op(.PUSH1), 0x1,
        op(.PUSH1), 0x9,
        op(.ADD),
        op(.PUSH1), 0x20,
        op(.DIV),
    });
}

test "MOD instruction" {
    try volatileStackTestValue(3, &.{
        op(.PUSH1), 5,
        op(.PUSH1), 23,
        op(.MOD),
    });
}

test "PUSH2 instruction" {
    try volatileStackTestValue(3526993988, &.{
        op(.PUSH2), 0x05, 0xad,
        op(.PUSH2), 0xf7, 0x02,
        op(.ADD),
        op(.PUSH2), 0xd4, 0xfc,
        op(.MUL),
    });
}

test "PUSH3 instruction" {
    try volatileStackTestValue(4849358562, &.{
        op(.PUSH3), 0x23, 0xe0, 0x93,
        op(.PUSH3), 0x67, 0x79, 0x43,
        op(.ADD),
        op(.PUSH3), 0x00, 0x02, 0x13,
        op(.MUL),
    });
}

test "PUSH32 instruction" {
    try volatileStackTestValue(85970811241406490303390531509016784217088394200819083899633365944276094183929, &.{
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.PUSH32),
        0x4d, 0x91, 0x78, 0x58,
        0x22, 0xda, 0x1d, 0x2c,
        0x25, 0x44, 0xea, 0x96,
        0x20, 0x4b, 0x72, 0x47,
        0xbf, 0x7f, 0x15, 0x9b,
        0xd9, 0x0b, 0xbb, 0x80,
        0xa5, 0x5e, 0xc6, 0x63,
        0x1e, 0x49, 0x6c, 0x17,
        op(.ADD),
    });
}

test "DUP1 instruction" {
    try volatileStackTestValue(25, &.{
        op(.PUSH1), 0x5,
        op(.DUP1),
        op(.MUL),
    });
}

test "DUP2 instruction" {
    try volatileStackTestValue(48, &.{
        op(.PUSH1), 0x5,
        op(.PUSH1), 0x8,
        op(.PUSH1), 0x6,
        op(.DUP2),
        op(.MUL),
    });
}

test "DUP3 instruction" {
    try volatileStackTestValue(30, &.{
        op(.PUSH1), 0x5,
        op(.PUSH1), 0x8,
        op(.PUSH1), 0x6,
        op(.DUP3),
        op(.MUL),
    });
}

test "SWAP1 instruction" {
    try volatileStackTestValue(10, &.{
        op(.PUSH1), 0x2,
        op(.PUSH1), 0x1,
        op(.SWAP1),
        op(.PUSH1), 0x5,
        op(.MUL),
    });
}

test "SWAP2 instruction" {
    try volatileStackTestValue(20, &.{
        op(.PUSH1), 0x4,
        op(.PUSH1), 0x2,
        op(.PUSH1), 0x1,
        op(.SWAP2),
        op(.PUSH1), 0x5,
        op(.MUL),
    });
}

test "SDIV instruction" {
    try volatileStackTestValue(@as(Word, @bitCast(@as(SignedWord, -2))), &.{
        op(.PUSH32),
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
        op(.PUSH1), 0x2,
        op(.SDIV),
    });
}

test "EXP instruction" {
    try volatileStackTestValue(4782969, &.{
        op(.PUSH1), 0x7,
        op(.PUSH1), 0x9,
        op(.EXP),
    });
}

test "EXP instruction exponent 0" {
    try volatileStackTestValue(1, &.{
        op(.PUSH1), 0x0,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 1" {
    try volatileStackTestValue(50885698490394846300529650755160262542539216671430528467191833472526591786466, &.{
        op(.PUSH1), 0x1,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 2" {
    try volatileStackTestValue(11978948873077291082614935807129539229662568818552917922358889902544049961860, &.{
        op(.PUSH1), 0x2,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 3" {
    try volatileStackTestValue(37345024310738433181113357916941771707155294456053137591045008100969753247368, &.{
        op(.PUSH1), 0x3,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 4" {
    try volatileStackTestValue(20779191417530337471435148661939714880243222816637389320675012265821831961616, &.{
        op(.PUSH1), 0x4,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 5" {
    try volatileStackTestValue(60623049136096303768541319095352851060905021887177462200724055449315697792544, &.{
        op(.PUSH1), 0x5,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 255" {
    try volatileStackTestValue(57896044618658097711785492504343953926634992332820282019728792003956564819968, &.{
        op(.PUSH1), 0xff,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "EXP instruction exponent 256" {
    try volatileStackTestValue(0, &.{
        op(.PUSH2), 0x01, 0x00,
        op(.PUSH32),
        0x70, 0x80, 0x48, 0xe2,
        0x39, 0xd9, 0xf4, 0x5b,
        0x12, 0x6e, 0x12, 0xca,
        0x88, 0x34, 0x8d, 0xc0,
        0x05, 0xf1, 0xbd, 0x4b,
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.EXP),
    });
}

test "SIGNEXTEND instruction" {
    try volatileStackTestValue(115792082335569848633007197573932045576244532214550284317904613665618839272930, &.{
        op(.PUSH12),
        0x3c, 0x66, 0x08, 0x01,
        0xb8, 0xeb, 0x42, 0x5f,
        0x57, 0x08, 0xfd, 0xe2,
        op(.PUSH1), 28,
        op(.SIGNEXTEND),
    });
}

test "LT instruction true" {
    try volatileStackTestValue(1, &.{
        op(.PUSH1), 93,
        op(.PUSH1), 58,
        op(.LT),
    });
}

test "LT instruction false" {
    try volatileStackTestValue(0, &.{
        op(.PUSH1), 58,
        op(.PUSH1), 93,
        op(.LT),
    });
}

test "GT instruction true" {
    try volatileStackTestValue(1, &.{
        op(.PUSH1), 58,
        op(.PUSH1), 93,
        op(.GT),
    });
}

test "GT instruction false" {
    try volatileStackTestValue(0, &.{
        op(.PUSH1), 93,
        op(.PUSH1), 58,
        op(.GT),
    });
}

test "EQ instruction true" {
    try volatileStackTestValue(1, &.{
        op(.PUSH1), 58,
        op(.PUSH1), 58,
        op(.EQ),
    });
}

test "EQ instruction false" {
    try volatileStackTestValue(0, &.{
        op(.PUSH1), 93,
        op(.PUSH1), 58,
        op(.EQ),
    });
}

test "ISZERO instruction true" {
    try volatileStackTestValue(0, &.{
        op(.PUSH1), 0x69,
        op(.ISZERO),
    });
}

test "ISZERO instruction false" {
    try volatileStackTestValue(1, &.{
        op(.PUSH1), 0x0,
        op(.ISZERO),
    });
}

test "BYTE instruction 29th byte" {
    try volatileStackTestValue(1, &.{
        op(.PUSH3), 0x1, 0x2, 0x3,
        op(.PUSH1), 29,
        op(.BYTE),
    });
}

test "BYTE instruction 30th byte" {
    try volatileStackTestValue(2, &.{
        op(.PUSH3), 0x1, 0x2, 0x3,
        op(.PUSH1), 30,
        op(.BYTE),
    });
}

test "BYTE instruction 31th byte" {
    try volatileStackTestValue(3, &.{
        op(.PUSH3), 0x1, 0x2, 0x3,
        op(.PUSH1), 31,
        op(.BYTE),
    });
}

test "SHL instruction shift 1" {
    try volatileStackTestValue(6, &.{
        op(.PUSH1), 0x3,
        op(.PUSH1), 1,
        op(.SHL),
    });
}

test "SHL instruction shift 8" {
    try volatileStackTestValue(768, &.{
        op(.PUSH1), 0x3,
        op(.PUSH1), 8,
        op(.SHL),
    });
}

test "SHR instruction shift 8" {
    try volatileStackTestValue(3, &.{
        op(.PUSH2), 0x3, 0x0,
        op(.PUSH1), 8,
        op(.SHR),
    });
}

test "SHR instruction shift 2" {
    try volatileStackTestValue(64, &.{
        op(.PUSH2), 0x1, 0x0,
        op(.PUSH1), 2,
        op(.SHR),
    });
}

test "SAR instruction shift 2 no sign extension" {
    try volatileStackTestValue(1130782121458165970933310400475467850129589694000396133197827968827276656640, &.{
        op(.PUSH32),
        0x0a, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        op(.PUSH1), 2,
        op(.SAR),
    });
}

test "SAR instruction shift 2 with sign extension" {
    try volatileStackTestValue(102448860204109836966557922283077387221740826276435889667723213975751265091584, &.{
        op(.PUSH32),
        0x8a, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        op(.PUSH1), 2,
        op(.SAR),
    });
}

test "SAR instruction shift 3 with sign extension" {
    try volatileStackTestValue(109120474720713016195064453645882647537505405471038226853590398991832197365760, &.{
        op(.PUSH32),
        0x8a, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        op(.PUSH1), 3,
        op(.SAR),
    });
}

test "POP instruction" {
    try volatileStackTestValue(1, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 0x02,
        op(.POP),
    });
}

test "PC instruction" {
    try volatileStackTestValue(2, &.{
        op(.PUSH1), 0x69,
        op(.PC),
    });
}

test "JUMP instruction invalid jump location" {
    try volatileStackTestError(error.InvalidJumpLocation, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 7,
        op(.JUMP),
        op(.PUSH1), 0x02, // this push is skipped
        op(.PUSH1), 0x03,
        op(.ADD),
    });
}

test "JUMPI instruction false invalid jump location" {
    try volatileStackTestError(error.InvalidJumpLocation, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 0, // condition
        op(.PUSH1), 9, // destrination
        op(.JUMPI),
        op(.PUSH1), 0x02, // this push is skipped
        op(.PUSH1), 0x03,
        op(.ADD),
    });
}

test "JUMPI instruction true invalid jump location" {
    try volatileStackTestError(error.InvalidJumpLocation, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 1, // condition
        op(.PUSH1), 9, // destrination
        op(.JUMPI),
        op(.PUSH1), 0x02, // this push is skipped
        op(.PUSH1), 0x03,
        op(.ADD),
    });
}

test "JUMP instruction valid jump location" {
    try volatileStackTestValue(4, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 7,
        op(.JUMP),
        op(.PUSH1), 0x02, // this push is skipped
        op(.JUMPDEST),
        op(.PUSH1), 0x03,
        op(.ADD),
    });
}

test "JUMPI instruction false valid jump location" {
    try volatileStackTestValue(5, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 0, // condition
        op(.PUSH1), 9, // destrination
        op(.JUMPI),
        op(.PUSH1), 0x02, // this push is skipped
        op(.JUMPDEST),
        op(.PUSH1), 0x03,
        op(.ADD),
    });
}

test "JUMPI instruction true valid jump location" {
    try volatileStackTestValue(4, &.{
        op(.PUSH1), 0x01,
        op(.PUSH1), 1, // condition
        op(.PUSH1), 9, // destrination
        op(.JUMPI),
        op(.PUSH1), 0x02, // this push is skipped
        op(.JUMPDEST),
        op(.PUSH1), 0x03,
        op(.ADD),
    });
}

test "SSLOAD/SSTORE instructions" {
    try volatileStackTestValue(69, &.{
        op(.PUSH1), 69,  // value
        op(.PUSH1), 0x5, // key
        op(.SSTORE),
        op(.PUSH1), 0x5, // key
        op(.SLOAD),
    });
}

test "MSTORE/MLOAD instructions" {
    try volatileStackTestValue(100, &.{
        op(.PUSH1), 100,
        op(.PUSH1), 36,
        op(.MSTORE),
        op(.PUSH1), 36,
        op(.MLOAD),
    });
}

test "MSTORE8/MLOAD instructions" {
    try volatileStackTestValue(100, &.{
        op(.PUSH1), 100,
        op(.PUSH1), 35,
        op(.MSTORE8),
        op(.PUSH1), 4,
        op(.MLOAD),
    });
}

test "MSIZE instructions" {
    try volatileStackTestValue(418, &.{
        op(.PUSH1), 100,
        op(.PUSH2), 0x01, 0xa1,
        op(.MSTORE8),
        op(.MSIZE),
    });
}
