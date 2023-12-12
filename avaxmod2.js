const Web3 = require('web3');

// Connect to an Ethereum node (replace with your Infura API key or node URL)
const web3 = new Web3('https://mainnet.infura.io/v3/8f451bba66244e60b2f1097a9582699c');

// Replace with your actual smart contract ABI and address
const contractAddress = '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4';
const contractABI = [
  {
    "constant": false,
    "inputs": [{"name": "_newValue", "type": "uint256"}],
    "name": "setValue1",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [{"name": "_newValue", "type": "string"}],
    "name": "setValue2",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "value1",
    "outputs": [{"name": "", "type": "uint256"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "value2",
    "outputs": [{"name": "", "type": "string"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }
];

const contract = new web3.eth.Contract(contractABI, contractAddress);

// Example: Call setValue1 function
const newValue1 = 42;
contract.methods.setValue1(newValue1).send({ from
: '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4' })
.on('transactionHash', (hash) => {
console.log('Transaction Hash:', hash);
})
.on('confirmation', (confirmationNumber, receipt) => {
console.log('Confirmation Number:', confirmationNumber);
console.log('Receipt:', receipt);
})
.on('error', (error) => {
console.error('Error:', error);
});
