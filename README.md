# Banquet

Banquet is  a small and speedy cardgame. This repository has playable on cli codes written in ruby. 

バンケットはゲームマーケット2013で出版された小さくて手軽なカードゲームです。このレポジトリはこのカードゲームをテキストベースのコンソール上で遊ぶことが出来るプログラムです。


![enter image description here](https://cdn-ak2.f.st-hatena.com/images/fotolife/o/oneforowl/20170806/20170806142555.png)


## Usage/利用法

```shell
$ cd ./your_download_repository_dir/
& gem install bundler (unless you have installed bundler-gem)
$ bundle install
$ ruby main.rb
```

## English

### Purpose
In this two player card drafting game, both players compete to get the most points from their single row of animals. However, each animal has various effects that can cause you to rearrange your row for more points or to interfere with your opponent, among other things. When both players have 6 cards in a row in front of them, all game ending effects from animals are applied and the player with the most points wins.

### Game Flow

 1. First shuffle the 24 cards to make a draw pile.
 2. Next, deal 6 cards to each player.
 3. Each player chooses a card from their hand and places it face down. Each player also chooses one card to discard from their hand.
 4. Repeat this three times, and both players will have 3 cards in her/his hand. Advance to step 5.
 5. Each players chooses one of his hand cards and puts forward. Both reveal at the same time, place their cards and place to the rightmost of the row, and apply any card effects..
 6. Repeat step 5 with the cards in front of you, and return to step 2 until the drawpile is empty.
 7. When the drawpile is empty the 6 cards in front of each player are scored. The cards' effects are applied and points are totaled. The player with the most points is the winner.

Thanks for translation,  Zaphiel.
 https://boardgamegeek.com/thread/1189174/translation-help

## 日本語

###ゲームの目的

このゲームはカードを１列に並べていき、その勝利点の合計を競います。各プレイヤーは１枚ずつカードを公開してその効果を解決し、自分の列の一番端へと加えていきます。これを６回繰り返すとゲームが終了し各プレイヤーは自分の列に並んだカードの勝利点を計算します。終了時に最も多くの勝利点を持っているプレイヤーが勝者です。

###ゲームの流れ

 1. まず24枚のカードをよくシャッフルし、山札とします
 2. 次に各プレイヤーに6枚ずつ伏せたままカードを配ります
 3. プレイヤーは配られたカード束の中から自分の列に加えたいカードを1枚選び、手札として伏せます。さらに不要なカードを1枚選び伏せたまま捨て札とします。
 4. 配られたカード束が残っていれば、対戦相手と配られたカード束を交換して(3)を繰り返します。3回繰り返して手元にある手札が3枚になり、カード束がなくなったら(5)に進みます。
 5. 各プレイヤーは３枚の手札から１枚を伏せたまま自分の前に出します。両者が出し終えたらカードを表にし列の右端へ並べ、表にしたカードに効果があれば解決します。
 6. (5)を繰り返して3枚の手札をすべて列に加え終えた時、山札が残っていれば(2)まで戻り同じように手札を3枚作って列に加えます。
 7. 山札がなくなり6枚のカードを表にしたらゲーム終了です。カードの効果をよく読んで自分の列に並ぶカードの勝利点を合計します。より多くの勝利点を得たプレイヤーが勝者となります。
