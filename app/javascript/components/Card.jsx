import React, { Component } from 'react';
import PropTypes from 'prop-types';

const images = require.context('../images');

class Card extends React.Component {
  render() {
    // debugger;
    return (
        <img src={images(`./4_C.png`).default} alt={this.describe()} />
    );
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
