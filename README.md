# pokedex

Flutterで作った簡単なポケモン図鑑だよ  
github pagesでもみれるよ  
https://nemoramune.github.io/pokedex-flutter/

Flutterのライブラリやデザインパターンを学ぶ上で作ったアプリだよ  
主なライブラリはこんな感じ

| ライブラリ                 | 概要                                                                        |
| -------------------------- | --------------------------------------------------------------------------- |
| flutter_hooks              | React HooksのFlutter版 useStateとか使えるよ                                 |
| hooks_riverpod             | Riverpodっていう状態管理ライブラリをFlutter Hooks版                         |
| dio                        | Httpクライアント インターネットの通信をいい感じにしてくれる                 |
| retrofit                   | dioをさらに使いやすくするラッパーライブラリ AndroidのRetrofitと同じ感じだよ |
| freezed_annotation         | immutableなデータクラスを作ってくれるライブラリ KotlinのDataClassみたいなの |
| hive                       | NoSQLなデータベースだよ 使いやすいね 動作が早いらしいよ                     |
| go_router                  | Flutterのルーティングをいい感じにしてくれるライブラリ                       |
| infinite_scroll_pagination | 無限スクロールとかページネーションを簡単に作れるライブラリ                  |
| slang                      | テキストをいい感じに管理してくれる flutter pub run slang をする必要があるよ |

なんとなくこんな感じのフローだよ
基本的にPokeDexにデータがあってそれを編集していく感じ


![pokemon-flow2](https://user-images.githubusercontent.com/109070415/218296513-b9610cfc-81ea-4438-8de2-a6d03a292a5c.svg)
