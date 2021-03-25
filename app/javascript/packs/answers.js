$(document).on('turbolinks:load', function() {
  $('.answers, .best-answer').on('click', '.edit-answer-link',function(e) {
    e.preventDefault();
    $(this).hide()

    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })

  $('form.new-answer').on('ajax:success', function(e) {
    let answer = e.detail[0].answer
    let links = e.detail[0].links
    let files = e.detail[0].files
    $('.answers').append('<p>' + answer.body + '</p>')
    $.each(links, function(index, link) {
      $('.answers').append('<br><a href=' + link.url + ' target=_blank >' + link.name + '</a>')
    })
    $.each(files, function(index, file) {
      $('.answers').append('<br><a href=' + file.url + ' target=_blank >' + file.name + '</a>')
    })
    
  })
    .on('ajax:error', function(e) {
  
      let errors = e.detail[0]
    

      $('.answer-errors').append('<p>error(s):</p>')
      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>')
      })      
    })
});