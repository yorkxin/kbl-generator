KKBOX Playlist (KBL) Generator

# KKBOX Playlist (KBL 檔) 製作方式

## 緣起

* 有人說想要聽 ACG 的音樂
* 明明 KKBOX 裡面有很多卻不知道哪裡有完整列表
* 而 KKBOX 現階段的共享歌單功能並不利於「常常會更改的歌單」
  * 共享出去的歌單無法修改
  * 修改本機歌單必須重新發佈成新的歌單

因此，希望有一個方法，只要找出 KKBOX 內的音樂列表，就可以製作出 KBL 檔。

**Disclaimer:** 本人任職於 KKBOX ，但工作內容與 KKBOX 服務本身無關，是以使用者的角度來製作本工具。請不要當做 KKBOX 對此工具有任何背書。使用本工具製作出來的 KBL 檔可能會對你的 KKBOX 曲庫有負面影響。

## 關於檔案格式

看起來是 XML 但實際上不是，因為第一行沒有宣告 header 。

要用程式輸出的話可能是用 XML builder 建立，然後把第一行刪掉。

## 關於 KKBOX 的歌單輸出

有 Export 可以另存成 KBL 檔，但其實在 OS X 版，全選然後按 Command + C 會複製成以下文字：

    W:Wonder tale kkbox://play_song_24855760
    Fantastic future kkbox://play_song_24855727
    to the beginning (動畫【Fate/Zero】片頭曲) kkbox://play_song_8907921

這樣的話就可以用 Regexp 處理了。

## 關於歌單檔的最小需求

見 sample.kbl 檔。

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

另外 KBL 檔歌單可以多載歌單，意思是說一個檔案裡存在多份歌單，匯入的時候，會一起匯入。但重要的是在 `<package>/<playlistcnt>` 裡面指定有幾份歌單，不指定的話，不管有多少 `<playlist>` 都不會匯入成功。

## 產生器

genkbl.rb 。用法是丟進 STDIN 它會吐 KBL source 到 STDOUT，需使用 unix pipe 來方便作業。

1. 把所有 id 放在 `ids.txt`
2. 執行：

        cat ids.txt | ruby genkbl.rb > playlist.kbl

3. 打開 `playlist.kbl`


## 作業方式

待議。至於歌單在此：

https://docs.google.com/spreadsheets/d/1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs/edit?usp=sharing

以目前 KKBOX 的功能，應該是要自己手動加入歌單，因為「共享歌單」不能編輯，若編輯則需要重新發佈，會成為新的歌單。

---

以上僅實驗 KKBOX for Mac 。
