React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

module.exports = class FileQuestion extends React.Component
  render: ->
    <div>
      <div className="files">
        {@renderFiles()}
      </div>

      <div><label>Upload file(s)</label></div>
      <input type="file" onChange={@addFile}/>

      <label htmlFor={@props.data.id + "-no-photo"}>
        <input
          checked={@props.answer?.selected?.length == 0}
          type="radio"
          onChange={@resetFiles}
          value={[]}
          id={@props.data.id + "-no-photo"}
        />
        <span className="label-body">No photo</span>
      </label>
    </div>

  renderFiles: =>
    @props.answer?.selected?.map (file) =>
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
    try
      reader.readAsDataURL(file)
    catch
      null

  addFile: (e) =>
    QuestionnaireStore.addAnswer(@props.data.id, e.target.files[0])

  deleteFile: (file) =>
    QuestionnaireStore.removeAnswer(@props.data.id, file)

  resetFiles: =>
    QuestionnaireStore.selectAnswer(@props.data.id, [])
