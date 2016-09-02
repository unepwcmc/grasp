_ = require("underscore")
async = require("async")
{EventEmitter} = require("events")
require("whatwg-fetch")

class ImageStore extends EventEmitter
  storeImages: (report, done) =>
    @storeImagesFor("live", report, (updatedReport) =>
      @storeImagesFor("dead", updatedReport, done)
    )

  deleteImage: (file) ->
    return unless file.url

    token = document.getElementsByName("csrf-token")[0].content
    fetch(file.url, {
      method: "DELETE",
      credentials: 'include',
      headers: {'X-CSRF-Token': token},
    }).then((response) ->
      console.log("deleted, #{response.status}")
    )


  storeImagesFor: (type, report, done) ->
    async.map((report.answers?[type] || []), ((ape, next) =>
      async.map((ape["photo_#{type}"]?.selected || []), @uploadPhotoFor(report), (err, uploadedPhotos) ->
        ape["photo_#{type}"].selected = uploadedPhotos if ape["photo_#{type}"]?.selected
        next(null, ape)
      )
    ), (err, updatedApes) ->
      report.answers["type"] = updatedApes
      done(report)
    )

  uploadPhotoFor: (report) ->
    (photo, done) =>
      return done(null, photo) if photo.id

      @uploadFile(photo.file, report.id, (response) ->
        console.log("called for #{response.headers.get("Location")}")
        photo.url = response.headers.get("Location")
        photo.id = parseInt(response.headers.get("Image-Id"))

        done(null, photo)
      )

  uploadFile: (file, reportId, done) ->
    form = new FormData()
    form.append('image', file)

    token = document.getElementsByName("csrf-token")[0].content
    fetch("/reports/#{reportId}/images", {
      method: "POST",
      headers: {
        'X-CSRF-Token': token
      },
      body: form,
      credentials: 'include',
    }).then(done)

module.exports = new ImageStore()
