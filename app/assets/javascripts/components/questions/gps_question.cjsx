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
        <label htmlFor="latitude">Latitude</label>
        <input ref="latitude" id="latitude" type="number"
          onChange={@handleLatChange} value={@getLat()}/>
      </fieldset>

      <fieldset>
        <label htmlFor="longitude">Longitude</label>
        <input ref="longitude" id="longitude" type="number"
          onChange={@handleLngChange} value={@getLng()}/>
      </fieldset>

      <button className="button button-primary" onClick={@fetchCoords}>
        Use current location
      </button>
      {@renderLoading()}
    </div>

  renderLoading: => <small>Loading...</small> if @state.loading

  handleLatChange: (e) => @saveCoords(e.target.value, @getLng())
  handleLngChange: (e) => @saveCoords(@getLat(), e.target.value)

  fetchCoords: =>
    @setState({loading: true})
    navigator.geolocation?.getCurrentPosition (position) =>
      @setState({loading: false})
      @saveCoords(position.coords.latitude, position.coords.longitude)

  saveCoords: (lat, lng) =>
    QuestionnaireStore.selectAnswer(@props.data.id, {lat: lat, lng: lng})

  getLat: => (@props.answer?.selected?.lat || "")
  getLng: => (@props.answer?.selected?.lng || "")


module.exports = GpsQuestion
