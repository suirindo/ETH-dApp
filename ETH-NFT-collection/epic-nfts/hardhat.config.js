require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/IrM13UyzIZZHICnnW6OsmrvpfT6Tnezz",
      accounts: ["a269c3d9747958dfa7c04132e0935349441e8686feb3f8711c5ce24ee95fc7d8"],
    },
  },
};
