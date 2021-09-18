import React from "react"
import PropTypes from "prop-types"


class GameView extends React.Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render () {
    return (
      <div>
       {this.state.cards_in_deck}
      </div>
    );
  }

  componentDidMount() {
    this.fetchGame(this.props.path)
  }

  async fetchGame(path) {
   const response = await fetch(path, 
     {
       headers: {
         'Accept': 'application/json',
         'Content-Type': 'application/json'
       }
   }) 
   
   const json = await response.json()
   this.handleServerUpdate(json)
  }

  handleServerUpdate(json) {
    this.setState({
      cards_in_deck: json['cards_in_deck'],
    })
  }
}

GameView.propTypes = {
  path: PropTypes.string.isRequired
};


export default GameView
