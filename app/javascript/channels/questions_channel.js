import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  let template = require('./templates/question.hbs')

  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      this.perform('subscribed')
      console.log('connected questions')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.user_id != data.question.user_id ) {
        const Handlebars = require("handlebars");
        let source = "<div data-question-id='{{{ question.id }}}'> <p><a href='{{{ question_path }}}'> {{{ question.title }}} </p> </div>"
        let resource = Handlebars.compile(source);
        $('.questions').append(resource(data))
      }
    }
  })
})  