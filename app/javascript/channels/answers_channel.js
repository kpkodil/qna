import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  const questionId = $('.question').data('questionId')

  let answersList = $('.answers');
  let template = require('./templates/answer.hbs')

  consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
    connected() {
      // Called when the subscription is ready for use on the server
      // console.log(consumer)
      // console.log(consumer.subscriptions)
      console.log('Connected to question_' + questionId + '/answers' )
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.user_id != data.answer.user_id ) {

        let linksHTML = ''
        $.each(data.links, function(index, link) {
          linksHTML += '<div data-link-id="'+ link.id +'"><li><a target="_blank" href="'+ link.url +'">'+ link.name +'</a></li>'
        })
        linksHTML += '</div>'
        data.links = linksHTML

        let filesHTML = ''
        $.each(data.files, function(index, file) {
          filesHTML += '<div data-attached-file-id="'+ file.id +'"><p><a target="_blank" href=' + file.url + ' target=_blank >' + file.name + '</a></p>'
        }) 
        data.files = filesHTML
        
        answersList.append(template(data))
        answersList.append('<p>Answer rating:</p><div class="rating">0</div><p class="vote "><a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/"' + data.answer.id  +  '"/vote_for">+1</a> | <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/"' + data.answer.id  +  '"/vote_against">-1</a></p>')
      }
    }
  })
})
