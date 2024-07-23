const std = @import("std");

const GMA_DECL = "GOOD MORNING AMERICA!!!";

pub const Token = union(enum) { good_morning_america, proc, t_var, out, lparen, rparen, number: f64, string: []u8 };
pub const LexerError = error{ DidNotSayGoodMorning, UnexpectedCharacter };

pub const Lexer = struct {
    at: usize,
    source: []u8,
    alloc: std.mem.Allocator,

    pub fn lex(self: *Lexer) !std.ArrayList(Token) {
        var tok = std.ArrayList(Token).init(self.alloc);
        // expect gma
        try tok.append(try gma(self));
        return tok;
    }

    fn gma(self: *Lexer) !Token {
        if (self.source.len >= GMA_DECL.len and std.mem.eql(u8, GMA_DECL, self.source[0..GMA_DECL.len])) {
            return Token.good_morning_america;
        } else {
            return error.DidNotSayGoodMorning;
        }
    }

    pub fn new(alloc: std.mem.Allocator, source: []u8) @This() {
        return @This(){
            .at = 0,
            .alloc = alloc,
            .source = source,
        };
    }
};
