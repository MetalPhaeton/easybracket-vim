easybracket-vim - Vimの括弧補完プラグイン
=========================================

easybracket-vimのライセンス
---------------------------

```
The MIT License (MIT)

Copyright (c) 2014 Ishibashi Hironori


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```



特徴
----

* 開き括弧を入力すると自動で閉じ括弧が補完される。
* 開き括弧を削除すると、自動補完された閉じ括弧も同時に削除される。
* 閉じ括弧が自動補完された後に、手動で閉じ括弧を入力すると、
  自動補完された閉じ括弧をスルーする。
* ビジュアルモードを選択した範囲を括弧でくくる。



使い方
------

以下はビジュアルモードで選択範囲を括弧でくくる方法。

| キー入力 (ビジュアルモード) | 意味                     |
|-----------------------------|--------------------------|
| `<Leader>(`                 | 選択範囲を`()`でくくる。 |
| `<Leader>{`                 | 選択範囲を`{}`でくくる。 |
| `<Leader>[`                 | 選択範囲を`[]`でくくる。 |
| `<Leader>a`                 | 選択範囲を`''`でくくる。 |
| `<Leader>q`                 | 選択範囲を`""`でくくる。 |

