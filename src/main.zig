const std = @import("std");
const json = std.json;
const zcord = @import("zCord");

const secrets = @embedFile("../secrets/secrets.json");

const Config = struct {
    vals: struct {
        secret: []const u8,
        torn_api: []const u8,
    },
    uptime: u64,
};

const config = x: {
    var stream = json.TokenStream.init(secrets);
    const res = json.parse(Config, &stream, .{});
    
    break :x res catch unreachable;
};

pub fn main() !void {
    try zcord.root_ca.preload(std.heap.page_allocator);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    var auth_buf: [0x100]u8 = undefined;
    _ = try std.fmt.bufPrint(&auth_buf, "Bot {s}", .{config.vals.secret});
}
