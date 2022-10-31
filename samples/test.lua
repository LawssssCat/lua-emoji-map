local module_name = arg[1] or "emoji_test"
local emoji_test = require(module_name)
assert(emoji_test(nil)==false)
assert(emoji_test(1)==false)
assert(emoji_test("1")==false)
assert(emoji_test("你")==false)
assert(emoji_test("你22")==false)
assert(emoji_test("😀")==true)
assert(emoji_test("😀🤣")==false)