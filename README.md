## OS

[作って理解する OS x86 系コンピュータを動かす理論と実装](https://www.amazon.co.jp/dp/B07YBQY75J) の写経

## env

```
brew install nasm qemu bochs
```

## development

```
# check
nasm -Xgnu -I. -o/dev/null src/**/*.s

# assembly
nasm -o foo.img src/bar/baz.s
```
