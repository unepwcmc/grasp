React = require("react")
Question = require("components/question")
QuestionnaireStore = require("stores/questionnaire_store")

class GpsQuestion extends React.Component
  constructor: (props, context) ->
    super(props, context)
    @state = {}

  render: ->
    <div>
      <fieldset>
        <label for="latitude">Latitude</label>
        <input ref="latitude" id="latitude" type="text"
          onChange={@handleLatChange} value={@getLat()}
        />
      </fieldset>
      <fieldset>
        <label for="longitude">Longitude</label>
        <input ref="longitude" id="longitude" type="text"
          onChange={@handleLngChange} value={@getLng()}
        />
      </fieldset>

      <button onClick={@fetchCoords}>📡</button> {@renderLoading()}
    </div>

  renderLoading: =>
    if @state.loading
      <small>Loading...</small>

  handleLatChange: (e) => @saveCoords(e.target.value, @getLng())
  handleLngChange: (e) => @saveCoords(@getLat(), e.target.value)

  fetchCoords: =>
    @setState({loading: true})

    navigator.geolocation?.getCurrentPosition (position) =>
      @setState({loading: false})
      @saveCoords(position.coords.latitude, position.coords.longitude)

  saveCoords: (lat, lng) =>
    QuestionnaireStore.selectAnswer(@props.data.id, {lat: lat, lng: lng})

  getLat: => (@props.data.selected?.lat || "")
  getLng: => (@props.data.selected?.lng || "")


module.exports = GpsQuestion
