import React from "react"
import PropTypes from "prop-types"

class Card extends React.Component {
  render () {
    return (
      <React.Fragment>
        Rank: {this.props.rank}
        Suit: {this.props.suit}
      </React.Fragment>
    );
  }
}

Card.propTypes = {
  rank: PropTypes.string,
  suit: PropTypes.string
};
export default Card
