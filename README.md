KKBOX Playlist (KBL) Generator

## 關於檔案格式

其實就是 XML。

## 關於 KKBOX 的歌單輸出

有 Export 可以另存成 KBL 檔，但其實在 OS X 版，全選然後按 Command + C 會複製成以下文字：

    W:Wonder tale kkbox://play_song_24855760
    Fantastic future kkbox://play_song_24855727
    to the beginning (動畫【Fate/Zero】片頭曲) kkbox://play_song_8907921

這樣的話就可以用 Regexp 處理了。

## 關於歌單檔的最小需求

見 sample.kbl 檔。

意思是說，要用程式製作一份歌單，最少需要哪些資訊，而根據實驗的結果，只需要 `<song_pathanme>` 就行了。

另外 KBL 檔歌單可以多載歌單，意思是說一個檔案裡存在多份歌單，匯入的時候，會一起匯入。但重要的是在 `<package>/<playlistcnt>` 裡面指定有幾份歌單，不指定的話，不管有多少 `<playlist>` 都不會匯入成功。

---

以上僅實驗 KKBOX for Mac 。

## LICENSE

Licensed under the MIT License. See `LICENSE` file.
