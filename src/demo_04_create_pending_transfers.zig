const std = @import("std");

const tb = @import("tigerbeetle.zig");
const demo = @import("demo.zig");

const Transfer = tb.Transfer;

pub fn main() !void {
    const transfers = [_]Transfer{
        Transfer{
            .id = 1001,
            .debit_account_id = 1,
            .credit_account_id = 2,
            .user_data = 0,
            .reserved = 0,
            .pending_id = 0,
            .ledger = 1,
            .timeout = std.time.ns_per_hour,
            .code = 0,
            .flags = .{
                .pending = true, // Set this transfer to be two-phase.
            },
            .amount = 9000,
        },
        Transfer{
            .id = 1002,
            .debit_account_id = 1,
            .credit_account_id = 2,
            .user_data = 0,
            .reserved = 0, //[_]u8{0} ** 32,
            .pending_id = 0,
            .ledger = 1,
            .timeout = std.time.ns_per_hour,
            .code = 0,
            .flags = .{
                .pending = true, // Set this transfer to be two-phase.
                .linked = true, // Link this transfer with the next transfer 1003.
            },
            .amount = 1,
        },
        Transfer{
            .id = 1003,
            .debit_account_id = 1,
            .credit_account_id = 2,
            .user_data = 0,
            .reserved = 0,
            .pending_id = 0,
            .ledger = 1,
            .timeout = std.time.ns_per_hour,
            .code = 0,
            .flags = .{
                .pending = true, // Set this transfer to be two-phase.
                // The last transfer in a linked chain has .linked set to false to close the chain.
                // This transfer will succeed or fail together with transfer 1002 above.
            },
            .amount = 1,
        },
    };

    try demo.request(.create_transfers, transfers, demo.on_create_transfers);
}