import React from 'react';
// import Card from './Card'
import PropTypes from 'prop-types';

const images = require.context('../images');

class CardView extends React.Component {
  render() {
    return (
        <img key={this.props.card.key()} src={images(`${this.props.card.getPath()}`).default} />
    );
  }
}

CardView.propTypes = {
  card: PropTypes.object
};

export default CardView;
