import React, { Component } from "react";
import Web3 from "web3";

class App extends Component {
  getInfuraProvider = () => {
    // TODO: support networks other than Rinkeby.
    // TODO: use an API key here.
    return Web3.providers.HttpProvider("https://rinkeby.infura.io");
  };
  getInfuraWeb3 = () => {
    return new Web3(this.getInfuraProvider());
  };

  setupWeb3 = async () => {
    if (window.ethereum) {
      // Metamask or a modern web3 provider is available.
      window.web3 = new Web3(window.ethereum);

      window.ethereum.on("accountsChanged", accounts => {
        // TODO: some app-specific logic when user changes
        // accounts in Metamask
      });

      // TODO: respond to this.
      window.ethereum.on("networkChanged", netId => {
        // TODO: some app-specific logic when user changes
        // networks in Metamask
      });

      // Try to access the user's account.
      try {
        await window.ethereum.enable();
      } catch (error) {
        console.log(error);
        // TODO: handle the case where the user
        // rejects account access.
      }
    } else if (window.web3) {
      // Legacy web3 provider is available.
      window.web3 = new Web3(window.web3.currentProvider);
    } else {
      // No web3 provider found, fall back to Rinkeby Infura.
      window.web3 = this.getInfuraWeb3();
    }

    // TODO: set the network
  };

  render = () => {
    return <div>Hello world</div>;
  };
}

export default App;
