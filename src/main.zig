const std = @import("std");
const json = std.json;
const zcord = @import("zCord");

const secrets = @embedFile("../secrets/secrets.json");

const Config = struct {
    token: []const u8,
    torn_api: []const u8,
};

fn get_secrets() !Config {
    comptime var stream = json.TokenStream.init(secrets);
    return try comptime json.parse(Config, &stream, .{});
}


pub fn main() !void {
    try zcord.root_ca.preload(std.heap.page_allocator);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    const config = try comptime get_secrets();
    var auth_buf: [0x100]u8 = undefined;
    const auth = try std.fmt.bufPrint(&auth_buf, "Bot {s}", .{config.token});

    const client = zcord.Client {
        .auth_token = auth,
    };
    
    const gateway = try client.startGateway(.{
        .allocator = gpa.allocator(),
        .intents = .{ .guild_messages = true },
    });
    defer gateway.destroy();
    
    while(true) {
        const event = try gateway.recvEvent();
        defer event.deinit();
        
        processEvent(event) catch |err| {
            std.debug.print("Event error: {}\n", .{err});
        };
    }
}

fn processEvent(event: zcord.Gateway.Event) !void {
    switch (event.name) {
        else => {},
    }
}
