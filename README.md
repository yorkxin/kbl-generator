# KKBOX Playlist (KBL) Generator

實驗從 KKBOX 曲目 ID 做出 KKBOX 歌單檔（KBL）的專案。

## 緣起

* <del>有人說</del>我想要聽 ACG 的音樂
* 明明 KKBOX 裡面有很多卻不知道哪裡有完整列表
* 而 KKBOX 現階段的共享歌單功能並不利於「常常會更改的歌單」
  * 共享出去的歌單無法修改
  * 修改本機歌單必須重新發佈成新的歌單

因此，希望有一個方法，只要找出 KKBOX 內的音樂列表，就可以製作出 KBL 檔。

**聲明:** 本人任職於 KKBOX，但這是私人作品，且是以逆向工程法來製作的，KKBOX 開發元「願境網訊」與此工具無關，對此工具沒有任何背書。

:warning: **警告:** 給一般用戶：使用本工具製作出來的 KBL 檔可能會對你的 KKBOX 曲庫有**負面影響**，如果你自認為電腦能力不夠強，請**不要**使用本程式產生出來的 KBL 檔，否則你最終可能要**清空所有歌單**才能繼續用 KKBOX。

## 使用方法

本程式僅實驗 KKBOX for Mac 。

按兩下滑鼠左鍵來打開 ACG.kbl。

* 一般用戶：尚有 bug ，不建議使用。
* Hacker：請看下面的「產生器」一節。

## 本包裝內建的歌單

* **ACG** - 日本動漫 ACG 歌單，原始檔在 [Google 試算表](https://docs.google.com/spreadsheets/d/1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs)。

### 一次產生所有歌單

在終端機輸入

    $ make

會去下載上列網址的 TSV 檔回來，並且用產生器轉換成 KBL 檔。

## 產生器

genkbl.rb 。用法是丟進 STDIN 它會吐 KBL source 到 STDOUT，需使用 unix pipe 來方便作業。

1. 準備一個檔案 `input.tsv` 格式如下（Tab 分隔檔）：

       Song ID	Song Name	Artist ID	Artist Name	Album ID	Artist Name

  每一欄以一個 Tab 字元 (`\t`) 分隔。

  例：

       17645049	美麗殘酷的世界 (「進擊的巨人」片尾曲)	945776	日笠陽子(Hikasa Yoko)	1685970	美麗殘酷的世界
       22021717	革命 Dualism	1176631	水樹奈奈 × T.M.Revolution	2084207	革命 Dualism (特別盤)
       38369455	Birth	830288	喜多村英梨 (Eri Kitamura)	3847501	証×明-SHOMEI-
       30772971	聖歌（動畫『雙斬少女KILL la KILL』插曲）	475589	藍井艾露 (Eir Aoi)	2828979	Aube初回限定盤
       30772977	天狼星（動畫『雙斬少女KILL la KILL』片頭曲）	475589	藍井艾露 (Eir Aoi)	2828979	Aube初回限定盤

2. 執行：

        ruby genkbl.rb < input.tsv > playlist.kbl

3. 打開 `playlist.kbl`

## 歌單製作流程

只適用於 KKBOX for Mac。

首先，準備 ACG.txt 裡面一行一個 KKBOX Song ID。穿插空行無妨，會直接無視。

然後匯入。:warning: **請注意**：這等同於在網頁上按一堆 Play 連結來把曲目灌進 KKBOX，副作用有：

* 暫存歌單會出現一大堆曲目
* 你正在播放的歌曲會變成曲目清單裡面的最後一首歌
* :warning: **音量注意**

執行方式：

    $ kbl import ACG.txt

懶得生檔案也可以直接用 `kbl import` 你就可以從 STDIN 灌進去。

:warning: 這時候**不要改到暫存歌單**，否則查詢到的 meta data 會從本機 DB 裡面消失（除非它有出現在別的歌單裡）。

會改到本機歌單的情況像是在專輯或歌手頁面對專輯或排行榜歌單按了「播放」連結，這時候暫存歌單就會被覆蓋。

最後是把 meta data 從本機 DB 撈出來：

    $ kbl dump ACG.txt -o ACG.tsv

一樣，也可以不加 `ACG.txt` 把 query song ids 從 STDIN 灌進去。

可以打開 `ACG.tsv` 看到裡面已經有 meta data 了。

最後是轉換成 KBL 檔：

    $ bundle exec genkbl.rb < ACG.tsv > ACG.kbl

現在可以打開 `ACG.kbl` 來看成果了。

## 關於檔案格式

基本上是 XML。格式見後文。

注意事項：

* UTF-8
* **不要 Escape HTML Entities** 如 `<` 、 `>` 、 `&` 等文字，KBL 檔是直接塞未 escape 的字串進去，如果 escape 的話，在該曲目不存在於本機 DB 的情況下，它會直接取用匯入歌單的 meta data，從而導致匯入之後的歌單出現 XML escaped entites。這個現象在該曲目第一次播放之後會解除（也就是 KKBOX client 去查詢了真正的 meta data）。

格式如下：

```xml
<utf-8_data>
  <kkbox_package>
    <kkbox_ver>04000016</kkbox_ver><!-- 固定值，要從 KKBOX 匯出檔取得 -->
    <playlist>
      <playlist_id>1</playlist_id><!-- 歌單順序編號，從 1 開始 -->
      <playlist_name>Playlist 1</playlist_name><!-- 歌單名稱，會變成匯入的歌單的名字 -->
      <playlist_descr>A Sample Playlist</playlist_descr><!-- 歌單說明，在 KKBOX GUI 看不到 -->
      <playlist_data>
        <song_data><!-- 一首歌的 meta data，欄位說明見下文 -->
          <song_name>Rising Hope</song_name>
          <song_artist>Lisa</song_artist>
          <song_album>Rising Hope</song_album>
          <song_genre></song_genre>
          <song_preference></song_preference>
          <song_playcnt></song_playcnt>
          <song_pathname>38437696</song_pathname>
          <song_type></song_type>
          <song_lyricsexist></song_lyricsexist>
          <song_artist_id>5404</song_artist_id>
          <song_album_id>3854689</song_album_id>
          <song_song_idx></song_song_idx>
        </song_data>
        <!-- more <song_data> nodes -->
      </playlist_data>
    </playlist>
    <!-- more <playlist> nodes, 其 playlist_id 要往上加 -->
    <package>
      <ver>1.0</ver>
      <descr>包裝說明</descr><!-- 不明？ -->
      <packdate>20140512232953</packdate><!-- timestamp 格式，strftime "%Y%m%d%H%M%S" -->
      <playlistcnt>1</playlistcnt><!-- 有幾個 <playlist> nodes-->
      <songcnt>177</songcnt><!-- 有幾首歌曲 -->
    </package>
  </kkbox_package>
</utf-8_data>
```

## 關於 KKBOX 的歌單輸出

有 Export 可以另存成 KBL 檔，但其實在 OS X 版，全選然後按 Command + C 會複製成以下文字：

    W:Wonder tale kkbox://play_song_24855760
    Fantastic future kkbox://play_song_24855727
    to the beginning (動畫【Fate/Zero】片頭曲) kkbox://play_song_8907921

這樣的話就可以用 Regexp 處理了。

## 關於歌單檔的最小需求

意思是說，要用程式製作一份歌單，最少需要哪些資訊。

根據 KKBOX 匯出的 kbl 檔可知有以下這些 meta info:

| field | 用途 | 資料型態 |
|-------|-----|---------|
| song_name | 曲名 | String |
| song_artist | Artist 名 | String |
| song_album | 專輯名 | String |
| song_genre | Genre ID | Integer |
| song_preference | 是否加☆ | Boolean (0 or 1) |
| song_playcnt | 播放次數 | Integer |
| song_pathname | 曲目編號 | Integer |
| song_type | （不明） | Integer |
| song_lyricsexist | 是否有歌詞 | Boolean (0 or 1) |
| song_artist_id | Artist 編號 | Integer |
| song_album_id | 專輯編號 | Integer |
| song_song_idx | 曲目在專輯裡的排序 | Integer |

原本認為，只需要 `<song_pathanme>` 就行了，但實際使用的結果發現，如果不填寫其他資料，會導致匯入資料庫的時候沒有任何資訊，結果就是出現空白曲目。如果該曲目在使用者的 KKBOX 完全沒有播過，就會發生這樣的情況。如果是曾經播過的就不會，所謂的曾經播過，包括：播過了之後把它從個人曲庫和播放記錄裡面移除，它會 cache 住，直到重新打開 KKBOX 程式。所以實際上很實驗出「確定有效的組合」。

以下這些可能必須存在才能成功匯入：

| field | 用途 | 取得方式 |
|-------|-----|---------|
| song_pathname | 曲目編號 | 網頁版播放按鈕的 `kkbox://play_song_XXXXXXXX` |
| song_artist_id | Artist 編號 | ？ |
| song_album_id | 專輯編號 | 網頁版全部播放按鈕的 `kkbox://playlist_??_XXXXXXXX`  |
| song_song_idx | 曲目在專輯裡的排序 | ？ |

試過的組合：

* ✕ `song_pathname`
* ✕ `song_pathname` + `song_artist_id`
* △ `song_pathname` + `song_artist_id` + `song_album_id`
* △ `song_pathname` + `song_album_id`

× = 匯入是空白，也無法播放。
△ = 匯入是空白，但按兩下可以播放，播放後就會查到曲目資訊。可以用，但不完美。

目前的 Workaround 是，在 `song_artist` 和 `song_album` 填入日文名稱，至少看得到文字，第一次播放就會取得正確資料了。但實際上這樣做仍然有 bug，就是某些情況下，後面播放的曲目會蓋掉前面曲目的歌手。你可以試著一直按下一首，就知道是什麼情況了。

另外 KBL 檔歌單可以多載歌單，意思是說一個檔案裡存在多份歌單，匯入的時候，會一起匯入。但重要的是在 `<package>/<playlistcnt>` 裡面指定有幾份歌單，不指定的話，不管有多少 `<playlist>` 都不會匯入成功。

## TODO

* genkbl.rb 搬進 kbl gem 裡面
* genkbl 要可以在 CLI 參數指定 Playlist Name

## LICENSE

Licensed under the MIT License. See `LICENSE` file.
