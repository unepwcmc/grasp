class @QuestionsRepo
  @questions: {}

  @register: (key, question) =>
    @questions[key] = question

  @fetch: (key) =>
    @questions[key]

  @all: =>
    @questions

