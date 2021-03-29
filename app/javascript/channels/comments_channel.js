import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  const questionId = $('.question').data('questionId')

  let template = require('./templates/comment.hbs')

  consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: questionId }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to question_' + questionId + '/comments')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      let comment = data.comment
      let commentableType = comment.commentable_type
      let commentableId = comment.commentable_id

      if ( commentableType == "Question" ) {
        $('.question .comments').append(template(data))
      } 
      if ( commentableType == "Answer" ) {
        let answerCommentsList = $('.answer-id-' + commentableId + ' .comments')
        answerCommentsList.append(template(data))
      }  
    }
  })
})