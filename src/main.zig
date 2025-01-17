const std = @import("std");
const lexer = @import("./lexer.zig");

pub fn main() !void {
    std.debug.print("== Welcome to RBOSCL ==");
    std.debug.print("(c) lawsmar 2024");
}

const expect = std.testing.expect;

test "can understand good morning" {
    const alloc = std.testing.allocator;
    const good_program = "GOOD MORNING AMERICA!!!   () )";
    const good_source = try alloc.alloc(u8, good_program.len);
    std.mem.copyForwards(u8, good_source, good_program);
    defer alloc.free(good_source);

    var lx = lexer.Lexer.new(alloc, good_source);
    var tokens = try lx.lex();
    defer tokens.deinit();

    std.debug.print("tokens = {any}", .{tokens.items});

    try expect(tokens.items[0] == lexer.Token.good_morning_america);
}
