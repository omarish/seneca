window.seneca =
    essay_id: 'essays/tranquil.html'
    essay: ''
    essay_arr: []
    essay_len: 0
    index: 0
    wpm: 200
    interval: null

    msecPerWord: (wpm) ->
        # Convert wpm to miliseocnds between words.
        1 / (wpm / 60 / 1000)

    stripHTML: (w) ->
        w.replace(/<(?:.|\n)*?>/gm, '')

    splitWord: (w) ->
        wordLength = w.length
        midpoint = Math.floor(w.length / 2)
        return [w.slice(0, midpoint), w[midpoint], w[1+midpoint..]]

N = window.seneca

$ ->
    $("#wpm").change () ->
        N.wpm = $($('#wpm').children(':selected')).val()

    $("#texts").change () ->
        clearInterval(N.interval)
        N.index = 0
        N.essay_id = $("#texts").children(":selected").val()
        $.ajax N.essay_id,
            async: false
            success: (resp) =>
                N.essay_arr = resp.split(' ')
                N.essay_len = N.essay_arr.length
                setWord("Have Fun :)", delta=1000)

    $('#texts').children().first().attr(':selected', 'true')

    refreshWord = () ->
        if N.index > N.essay_len
            clearInterval(N.interval)
        else
            setWord(N.stripHTML(N.essay_arr[N.index]))
            N.index++

    $left = $('#word > #left')
    $mid = $('#word > #mid')
    $right = $('#word > #right')

    getWordWidth = (word) ->
        w = $("<div class='word' style='display: inline-block'>#{word}</div>").appendTo('#essay')
        width = w.width()
        $('#essay').children().remove()
        return width

    setWord = (word, delta=0) ->
        if /[?,.!;]$/.test word
            N.interval = setTimeout(() ->
                refreshWord()
            , N.msecPerWord(N.wpm / 4) + delta)
        else
            N.interval = setTimeout(refreshWord, N.msecPerWord(N.wpm) + delta)

        [left, mid, right] = N.splitWord(word)

        $left.css('margin-left', -1 * getWordWidth(left))
        $left.html(left)
        $right.css('margin-left', getWordWidth(mid))
        $mid.html(mid)
        $right.html(right)
        
