React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")
ImageStore = require("stores/image_store")

module.exports = class FileQuestion extends React.Component
  render: ->
    <div>
      <div className="files">
        {@renderFiles()}
      </div>

      <div><label>Upload file(s)</label></div>
      <input type="file" onChange={@addFile}/>

      <label className="answer" htmlFor={@props.data.id + "-no-photo"}>
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
    @props.answer?.selected?.map((file) =>
      if file.url
        <p key={file.id} className="file">
          <img height=48 src="#{file.url}?size=thumb"></img>
          <small style={{color: "red"}} onClick={@deleteFile.bind(@, file)}>x</small>
        </p>
      else
        <p key={file.file.name + file.file.lastModifiedDate} className="file">
          {@renderImage(file.file)} {file.file.name}
          <small style={{color: "red"}} onClick={@deleteFile.bind(@, file)}>x</small>
        </p>
    )

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
    QuestionnaireStore.addAnswer(@props.data.id, {file: e.target.files[0]})
    QuestionnaireStore.saveOrUpdateReport()

  deleteFile: (file) =>
    ImageStore.deleteImage(file)
    QuestionnaireStore.removeAnswer(@props.data.id, file)
    QuestionnaireStore.saveOrUpdateReport()

  resetFiles: =>
    @props.answer?.selected?.map((file) =>
      ImageStore.deleteImage(file)
    )
    QuestionnaireStore.selectAnswer(@props.data.id, [])
    QuestionnaireStore.saveOrUpdateReport()
