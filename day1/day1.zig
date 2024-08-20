const std = @import("std");
const print = std.debug.print;
//Zig things you will learn
//Open file
//Write to file
//try to parse numbers out of strings
pub fn main() !void {
    const answer = try std.fs.cwd().createFile("answer.txt", .{});
    defer answer.close();

    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    // Wrap the file reader in a buffered reader
    // Since it's usually faster to read a bunch of bytes at once
    var buf_reader = std.io.bufferedReader(file.reader());
    var reader = buf_reader.reader();

    //we need an allocator for the line writer to print out the contents of the reader
    var line_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer line_allocator.deinit();
    var results: u32 = 0;

    while (try reader.readUntilDelimiterOrEofAlloc(line_allocator.allocator(), '\n', 1000)) |line| {
        _ = try answer.write(line);
        _ = try answer.write("\n");

        var al = std.ArrayList(u32).init(std.heap.page_allocator);

        for (line) |character| {
            if (character >= 48 and character <= 57) {
                try al.append(@intCast(character - 48));
                // print("{} ", .{character - 48});
            }
        }
        if (al.items.len > 0) {
            if (al.items.len == 1) {
                var t: u32 = 0;

                t += al.getLast() * 10;
                t += al.getLast();
                results += t;
            } else {
                var t: u32 = 0;
                t += al.items[0] * 10;
                t += al.getLast();
                results += t;
            }
        }
        print("Running Answer {d}", .{results});
        al.deinit();
        print("\n", .{});
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
