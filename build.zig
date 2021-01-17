const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("uefi", "src/main.zig");
    exe.setBuildMode(.ReleaseSmall);
    exe.setTarget(.{
        .cpu_arch = .x86_64,
        .cpu_model = .{ .explicit = &std.Target.x86.cpu.x86_64 },
        .os_tag = .uefi,
        .abi = .none,
    });
    exe.install();
}
