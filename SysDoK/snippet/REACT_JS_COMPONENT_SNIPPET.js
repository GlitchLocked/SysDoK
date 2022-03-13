// CLASS COMPONENT

import React, {Component} from 'react';

class ComponentClass extends Component {

  constructor(props) {
      super(props)
      this.state = {
      clef : 'valeur'
  }

      this.action = this.action.bind()
  }

 action() {
  const text = 'je lis'
  return text
 }

 render() {
   return (<div>
             <h1>Ping!</h1>
           </div>)
 }
}

export default ComponentClass;


// FUNCTION COMPONENT
// import React from 'react'

// const ComponentName = () => {

//     return (<div>
//            <h1>Ping!</h1>
//          </div>)
// }

// export default ComponentName