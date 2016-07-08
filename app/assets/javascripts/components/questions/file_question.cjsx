React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

module.exports = class FileQuestion extends Question
  render: ->
    <div className="question">
      <h3>{@props.data.question}</h3>

      <p style={@displayStyle()}>{@props.data.selected}</p>
      <div style={@editStyle()}>
        <div className="files">
          {@renderFiles()}
        </div>

        <div><label>Upload file(s)</label></div>
        <input type="file" onChange={@addFile}/>
      </div>
    </div>

  renderFiles: =>
    @props.data.selected?.map (file) =>
      <p key={file.name + file.lastModifiedDate} className="file">
        {@renderImage(file)} {file.name}
        <small style={{color: "red"}} onClick={@deleteFile.bind(@, file)}>x</small>
      </p>

  renderImage: (file) =>
    if(FileReader)
      imageRef = "image_#{file.lastModifiedDate}"

      @loadThumbnail(file, imageRef)
      <img key={imageRef} height=48 ref={imageRef} title={file.name}></img>

  loadThumbnail: (file, imageRef) ->
    reader = new FileReader()

    reader.onload = ((event) => @refs[imageRef].src = event.target.result)
    reader.readAsDataURL(file)

  addFile: (e) =>
    QuestionnaireStore.addAnswer(@props.data.id, e.target.files[0])

  deleteFile: (file) =>
    QuestionnaireStore.removeAnswer(@props.data.id, file)
