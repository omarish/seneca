window.wpm = 200

msecPerWord = (wpm) ->
    # Convert wpm to miliseocnds between words.
    1 / (wpm / 60 / 1000)

splitWord = (w) ->
    wordLength = w.length
    midpoint = Math.floor(w.length / 2)
    return [w.slice(0, midpoint), w[midpoint], w[1+midpoint..]]

$ ->
    $("#wpm").change () ->
        window.wpm = $($('#wpm').children(':selected')).val()

    window.essay = "[loading]"
    $.ajax "essays/tranquil.html",
        async: false
        success: (resp) =>
            window.essay = resp

    essay = window.essay
    essay_arr = essay.split(' ')
    essay_len = essay_arr.length
    index = 0

    refreshWord = () ->
        if index > essay_len
            console.info "Done!"
            clearInterval(interval)
        else
            setWord(essay_arr[index])
            index = index + 1

    $left = $('#word > #left')
    $mid = $('#word > #mid')
    $right = $('#word > #right')

    getWordWidth = (word) ->
        w = $("<div class='word' style='display: inline-block'>#{word}</div>").appendTo('#essay')
        width = w.width()
        $('#essay').children().remove()
        return width

    setWord = (word) ->
        if /[?,.!;]$/.test word
            setTimeout(() ->
                refreshWord()
            , msecPerWord(window.wpm / 4))
        else
            setTimeout(refreshWord, msecPerWord(window.wpm))

        [left, mid, right] = splitWord(word)

        $left.css('margin-left', -1 * getWordWidth(left))
        $left.text(left)
        $right.css('margin-left', getWordWidth(mid))
        $mid.text(mid)
        $right.text(right)

    # Let's try reading at 200wpm.
    refreshWord()
