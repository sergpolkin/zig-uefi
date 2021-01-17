const std = @import("std");
const builtin = @import("builtin");

const uefi = std.os.uefi;
const SimpleTextOutputProtocol = uefi.protocols.SimpleTextOutputProtocol;

var console_out: *SimpleTextOutputProtocol = undefined;

pub fn init() void {
    console_out = uefi.system_table.con_out.?;
}

pub fn outputString(buffer: [*:0]const u16) void {
    _ = console_out.outputString(buffer);
}

pub fn print(comptime format: []const u8, args: anytype) void {
    ConsoleOut.Writer.print(format, args) catch {};
}

const ConsoleError = error {};

const ConsoleOut = struct {
    fn print(context: void, buffer: []const u8) ConsoleError!usize {
        var out: [3:0]u16 = undefined;
        const view = std.unicode.Utf8View.initUnchecked(buffer);
        var it = view.iterator();
        while (it.nextCodepoint()) |codepoint| {
            // non-ascii replace with '_'
            if (codepoint < 0x80) {
                if (codepoint == 0xA) {
                    out[0] = 0xD;
                    out[1] = 0xA;
                }
                else {
                    out[0] = @intCast(u16, codepoint);
                    out[1] = 0;
                }
            }
            else
            {
                out[0] = '_';
                out[1] = 0;
            }
            out[2] = 0;
            _ = console_out.outputString(&out);
        }
        return buffer.len;
    }

    const Writer = std.io.Writer(void, ConsoleError, ConsoleOut.print) {
        .context = {},
    };
};
