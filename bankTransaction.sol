//SPDX-License-Identifier: MIT License

pragma solidity >0.8.1;

/* 
map transactions to a unique id for each transaction
 */
 
contract BankTransaction {
    struct Transaction {
        uint ID; // payment identifier from 0...n0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        address client;
        address payable recipient;
        uint amount;
        uint timestamp;
        string note;
        bytes32 hashed; // hash value of payment
    }

    // Transaction[] public transactions; // Removed array logic
    mapping (uint => Transaction) txs; // Maintain a mapping of transaction IDs to Transaction objects
    uint public count = 0;

    // Adding a new payment
    function addTransaction(address payable receiver, uint amount, string memory note) public {
        uint time = block.timestamp;
        uint id = generateID();
        txs[id] = Transaction(
            {
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
            }
        );
    }

    // Generate transaction ID 
    function generateID() public returns (uint) {
        count += 1;
        return count;
    }

    // Getting information about the payment by its identifier
    function getTransaction(uint id) public view returns (Transaction memory) {
        return txs[id];
    }

    // Getting all payments of a particular customer
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

    // Gas Optimization
    function gasOptimization() public pure returns (uint answer) {
        uint a = 3;
        uint b = 2;
        uint accuracy = 10**8;
        answer = (a * accuracy) / (b); // on frontend divide answer by accuracy
    }
}
