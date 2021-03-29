$(document).on('turbolinks:load', function() {

  $('form.new-comment').on('ajax:success', function(e) {
    let commentsList = $($(this)[0].parentNode).find('.comments')[0]
    let data = e.detail[0]
    let commentBody = data.comment.body
    let comment = '<li> '+ commentBody +' </li>'
    let commentHTML = $($.parseHTML(comment)).html()

    commentsList.append(commentHTML)
  })
    .on('ajax:error', function(e) {

      let errors = e.detail[0].errors    
      let errorsList = $($(this)[0].parentNode).find('.comment-errors')[0]

      errorsList.append($($.parseHTML('<p>error(s):</p>')).html())
      $.each(errors, function(index, value) {
        errorsList.append($($.parseHTML('<p>' + value + '</p>')).html())
      })      
    })
});