function limit_chars(textarea, limit, info, msg) {
    if (!msg) msg = 'You have %d characters left.'
    var text = textarea.value
    var textlength = text.length

    if (textlength > limit) {
        info.innerHTML = 'You cannot write more then ' + limit + ' characters!'
        textarea.value = text.substr(0,limit)
        return false
    } else {
        info.innerHTML = msg.sub('%d', limit - textlength)
        return true
    }
}
