const std = @import("std");

const GMA_DECL = "GOOD MORNING AMERICA!!!";
const NUMBERS = "1234567890";
const IDENTIFIER_CHARS = "abcdefghijklmnopqrstuvwxyz_" ++ NUMBERS;

pub const Token = union(enum) { good_morning_america, proc, t_var, out, lparen, rparen, number: f64, string: []u8, eof };
pub const LexerError = error{ DidNotSayGoodMorning, UnexpectedCharacter };

pub const Lexer = struct {
    at: usize,
    source: []u8,
    alloc: std.mem.Allocator,

    pub fn new(alloc: std.mem.Allocator, source: []u8) @This() {
        return @This(){
            .at = 0,
            .alloc = alloc,
            .source = source,
        };
    }

    pub fn lex(self: *Lexer) !std.ArrayList(Token) {
        var tok = std.ArrayList(Token).init(self.alloc);
        // expect gma
        try tok.append(try self.gma());

        while (true) {
            self.skip_whitespace();
            const cur = try self.next();
            if (cur == Token.eof) break;
            try tok.append(cur);
        }

        return tok;
    }

    fn gma(self: *Lexer) !Token {
        if (self.source.len >= GMA_DECL.len and std.mem.eql(u8, GMA_DECL, self.source[0..GMA_DECL.len])) {
            self.at = GMA_DECL.len;
            return Token.good_morning_america;
        } else {
            return error.DidNotSayGoodMorning;
        }
    }

    /// returns current and advances
    fn advance(self: *Lexer) u8 {
        const char = self.current();
        self.skip();
        return char;
    }

    fn skip(self: *Lexer) void {
        self.at += 1;
    }

    fn peek_n(self: *Lexer, i: usize) u8 {
        if (self.at + i >= self.source.len) {
            return '\x00';
        } else {
            return self.source[self.at + i];
        }
    }

    fn current(self: *Lexer) u8 {
        return self.peek_n(0);
    }

    fn skip_whitespace(self: *Lexer) void {
        while (self.at <= self.source.len) {
            const n = self.current();
            switch (n) {
                ' ' | '\t' | '\n' => {
                    // whitespace!
                    self.skip();
                },
                else => {
                    // not whitespace
                    break;
                },
            }
        }
    }

    fn next(self: *Lexer) !Token {
        const curr = self.advance();
        switch (curr) {
            '\x00' => {
                return Token.eof;
            },
            '(' => {
                return Token.lparen;
            },
            ')' => {
                return Token.rparen;
            },
            else => {
                std.debug.print("unex = '{c}'", .{curr});
                return error.UnexpectedCharacter;
            },
        }
    }
};
