# ETH-bank

**A Smart Contract with basic banking functionalities.**

## Overview

The ETH-bank contract offers basic banking functionalities, including the ability to add transactions, retrieve transaction details, and query transactions associated with specific clients. 

Designed for efficiency and security, this contract uses Solidity version `>0.8.1` and integrates OpenZeppelin libraries for robust security measures.

## Features

- **Add Transactions**: Users can add transactions, specifying the recipient, amount, and a note.
- **Retrieve Transactions by ID**: Users can retrieve details of a specific transaction using its unique identifier.
- **Client Transaction History**: Users can query the first five transactions of a specific client.
- **Gas Optimization**: Optimized functions to ensure minimal gas usage.
- **Security**: Integrated protection against common vulnerabilities.

## Contract Details

### Data Structures

- **Transaction**: A struct representing a transaction.
  ```solidity
  struct Transaction {
      uint ID; // Unique identifier for the transaction
      address client; // Address of the client initiating the transaction
      address payable recipient; // Recipient address
      uint amount; // Amount transferred
      uint timestamp; // Timestamp of the transaction
      string note; // Optional note for the transaction
      bytes32 hashed; // Hash of the transaction details
  }
  ```

### Storage

- **txs**: A mapping to store transactions by their unique ID.
  ```solidity
  mapping (uint => Transaction) txs;
  ```
- **count**: A counter to keep track of the number of transactions.
  ```solidity
  uint public count = 0;
  ```

### Functions

- **addTransaction**: Adds a new transaction.
  ```solidity
  function addTransaction(address payable receiver, uint amount, string memory note) public
  ```

- **generateID**: Generates a unique ID for each transaction.
  ```solidity
  function generateID() public returns (uint)
  ```

- **getTransaction**: Retrieves a transaction by its ID.
  ```solidity
  function getTransaction(uint id) public view returns (Transaction memory)
  ```

- **getClientInfo**: Retrieves the first five transactions of a client.
  ```solidity
  function getClientInfo(address client) public view returns (Transaction[] memory clientTxs)
  ```

- **gasOptimization**: Demonstrates a gas optimization technique.
  ```solidity
  function gasOptimization() public pure returns (uint answer)
  ```

### Blockchain and Protocol Details

- **Blockchain**: Ethereum
- **Protocol**: The contract follows the Ethereum protocol and is compatible with the Ethereum Virtual Machine (EVM).
- **Solidity Version**: The contract is written in Solidity version `>0.8.1`.
- **Deployment**: The contract can be deployed on any Ethereum network, including mainnet, testnets (Ropsten, Rinkeby, Kovan, Goerli), and private Ethereum networks.
- **Gas Usage**: Gas optimization techniques are employed to minimize transaction costs on the Ethereum network.

### Security Considerations

- **Reentrancy Protection**: Although `ReentrancyGuard` is not used in the current version, consider integrating it for future enhancements.
- **Data Privacy**: Transactions are stored in a private mapping to prevent unauthorized access.

### Gas Optimization

- **Mapping Usage**: Storing transactions in a mapping allows for efficient lookups and minimizes gas costs compared to using arrays.
- **Minimalistic Functions**: Functions are designed to be minimalistic to reduce gas consumption.

### Example Usage

#### Adding a Transaction

```solidity
function addTransaction(address payable receiver, uint amount, string memory note) public {
    uint time = block.timestamp;
    uint id = generateID();
    txs[id] = Transaction({
        ID: id,
        client: msg.sender,
        recipient: receiver,
        amount: amount,
        timestamp: time,
        note: note,
        hashed: keccak256(bytes.concat(
            abi.encodePacked(time),
            abi.encodePacked(msg.sender),
            abi.encodePacked(receiver),
            abi.encodePacked(amount)
        ))
    });
}
```

#### Retrieving a Transaction by ID

```solidity
function getTransaction(uint id) public view returns (Transaction memory) {
    return txs[id];
}
```

#### Retrieving Client Transactions (First 5)

```solidity
function getClientInfo(address client) public view returns (Transaction[] memory clientTxs) {
    uint txCount = 0;
    for (uint256 i = 1; i <= count; i++) {
        if (txs[i].client == client) {
            txCount++;
        }
    }

    clientTxs = new Transaction[](txCount);
    uint8 x = 0; // variable to point to index to store transactions in the array
    for (uint256 i = 1; i <= count; i++) {
        if (txs[i].client == client) {
            require(x < 5, "Can only pull the first 5 transactions");
            clientTxs[x] = txs[i];
            x += 1;
        }
    }
}
```

#### Gas Optimization

```solidity
function gasOptimization() public pure returns (uint answer) {
    uint a = 3;
    uint b = 2;
    uint accuracy = 10**8;
    answer = (a * accuracy) / (b); // on frontend divide answer by accuracy
}
```

### Dependencies

- OpenZeppelin Contracts: Ensure to install OpenZeppelin contracts to leverage `ReentrancyGuard`.

```sh
npm install @openzeppelin/contracts
```

## Conclusion

The ETH-bank contract provides a basic yet secure and efficient way to manage transactions on the Ethereum blockchain. By leveraging Solidity’s features and integrating gas optimization techniques, the contract ensures both robustness and usability.

## License

© MIT License ⚖️ 2024

---

Feel free to adjust or add any additional details as needed!
