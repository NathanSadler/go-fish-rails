import React from 'react';
import PropTypes from 'prop-types';

class Card extends React.Component {
  render() {
    return `${this.props.rank} of ${this.props.suit}`;
  }

  describe() {
    return `${this.props.rank} of ${this.props.suit}`;
  }
}

Card.propTypes = {
  rank: PropTypes.string,
  suit: PropTypes.string
};

export default Card;
