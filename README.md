# OpenZeplin

Convert an URL like `https://app.zeplin.io/project/XXXXXX/screen/YYYYY` passed
as a command line parameter to the form `zpl://screen?pid=XXXXXX&sid=YYYYY` and
open it.

## Installation

```sh
$ swift build -c release -Xswiftc -static-stdlib
$ cp ./.build/x86_64-apple-macosx10.10/release/OpenZeplin /usr/local/bin
```
