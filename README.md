Generate lua code from emoji codepoints to determine whether the string is emoji.

1. download 'emoji-data.txt' from [unicode website](https://www.unicode.org).
1. parse above file to lua code.

run:

```bash
bash update.sh --download --convert --test
```

output:

`emoji_test.lua`

![GitHub file size in bytes](https://img.shields.io/github/size/LawssssCat/lua-emoji-map/emoji_test.lua?style=plastic)
