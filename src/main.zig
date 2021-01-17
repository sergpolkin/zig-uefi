const std = @import("std");
const uefi = std.os.uefi;
const builtin = @import("builtin");

const console = @import("console.zig");

pub fn main() noreturn {
    console.init();

    console.outputString(uefi.system_table.firmware_vendor);
    console.print(" {x}\n", .{uefi.system_table.firmware_revision});

    console.print("{*}\n", .{uefi.handle});
    console.print("{*}\n", .{uefi.system_table});

    @panic("main");
}

pub fn panic(msg: []const u8, bt: ?*builtin.StackTrace) noreturn {
    console.print("!!! PANIC !!!\n{s}\n", .{msg});
    asm volatile(
        \\ cli
        \\ hlt
    );
    while(true) {}
}
