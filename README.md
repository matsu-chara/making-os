## OS

[作って理解するOS x86系コンピュータを動かす理論と実装](https://www.amazon.co.jp/dp/B07YBQY75J) の写経

## env

```
brew install nasm qemu bochs

go get -u github.com/yamnikov-oleg/nasmfmt
```


## development

```
# format
nasmfmt **/*.s

# check
nasm -Xgnu -I. -o/dev/null src/**/*.s

# assembly
nasm -o foo.img src/bar/baz.s
```
