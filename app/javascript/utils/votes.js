$(document).on('turbolinks:load', function() {

  $('.vote').on('ajax:success', function(e) {
    e.preventDefault()

    const rating = e.detail[0].rating
    console.log(rating)
    $(this).addClass('hidden')
    $($(this)[0].parentNode).find('.delete-vote').removeClass('hidden')
    $($(this)[0].parentNode).find('.rating').html(rating)
    
  })
    .on('ajax:error', function(e) {
      const errors = e.detail[0].errors
      const ratingErrors = $($(this)[0].parentNode).find('.rating-errors')
      console.log(e)
      console.log(errors)
      ratingErrors.append('<p>error(s) detected:')

      $.each(errors, function(index, value) {
        ratingErrors.append('<p>' + value + '</p>')
      })
        
    })

  $('.delete-vote').on('ajax:success', function(e) {
    e.preventDefault()

    const rating = e.detail[0].rating
    console.log(e)
    console.log(rating)
    $(this).addClass('hidden')
    $($(this)[0].parentNode).find('.vote').removeClass('hidden')
    console.log($($(this)[0].parentNode).find('.rating'))
    
    $($(this)[0].parentNode).find('.rating').html(rating)
    
  })
    .on('ajax:error', function(e) {
      const errors = e.detail[0].errors
      const ratingErrors = $($(this)[0].parentNode).find('.rating-errors')
      console.log(e)
      console.log(errors)
      ratingErrors.append('<p>error(s) detected:')

      $.each(errors, function(index, value) {
        ratingErrors.append('<p>' + value + '</p>')
      })
        
    })
})