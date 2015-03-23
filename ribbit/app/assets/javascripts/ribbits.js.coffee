# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Vars
textarea = document.getElementById 'ribbitText'
count    = document.getElementById 'charCount'
button   = document.getElementById 'ribbitBtn'

# f()
# za brojanje
countChars = (e) ->
  len = textarea.value.length
  count.innerHTML = len

  if len > 140
    count.className = "limit"
    button.setAttribute "disabled", "disabled"
  else
    count.className = ""
    button.removeAttribute "disabled"

# Events
textarea.addEventListener "keyup", countChars, false
textarea.addEventListener "keydown", countChars, false

