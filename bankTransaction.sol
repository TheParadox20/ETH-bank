//SPDX-Licence-Identifier: MIT

pragma solidity >0.8.1;

/* 
Two possible approaches:
    1.) create transactionss[] array with elements being of the transaction object
    2.) map transactions to a unique id for each transacton
        The transaction identifier can either be:
            i.)  Combination of deterministic letters and numbers, requires an extra array for case 2 above to track the ID's
            ii.) Incrementing an integer gradualy; "cheap" for option 2
Commented out option 1 compiled option 2
 */
contract BankTransaction{
    struct Transaction{
        uint ID; //payment identifier from 0...n0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        address client;
        address payable recipient;
        uint amount;
        uint timestamp;
        string note;
        bytes32 hashed;// hash value of payment
    }

    // Transaction[] public transactions;
    mapping (uint=>Transaction) txs;
    uint public count = 0;

//Adding a new payment
    function addTransaction(address payable receiver, uint amount, string memory note) public {
        uint time = block.timestamp;
        uint id = generateID();
        /* transactions.push(
            Transaction({
                ID: id,
                client: msg.sender,
                recipient: receiver,
                amount: amount,
                timestamp: time,
                note: note,
                hashed: ""
            })
        ); */
        txs[id] = Transaction(
            {
                ID: id,
                client: msg.sender,
                recipient: receiver,
                amount: amount,
                timestamp: time,
                note: note,
                hashed: keccak256(bytes.concat(abi.encodePacked(time),abi.encodePacked(msg.sender),abi.encodePacked(receiver),abi.encodePacked(amount)))
            }
        );
    }
//Generate transaction ID 
    function generateID() public returns (uint){
        count+=1;
        return count;
    }

//Getting information about the payment by it's identifier
    function getTransaction(uint id) public view returns(Transaction memory){
        /* for (uint256 i = 0; i < transactions.length; i++) {
            if(keccak256(abi.encodePacked(transactions[i].ID))==keccak256(abi.encodePacked(id))){
                return transactions[i];
            }
        } */
        return txs[id];
    }
//Getting all payments of a particular customer
    function getClientInfo(address client) public view returns(Transaction memory){
        /* for (uint256 i = 0; i < transactions.length; i++) {
            if(transactions[i].client==client){
                return transactions[i];
            }
        } */
        for (uint256 i = 0; i <= count; i++) {
            if(txs[i].client==client){
                // clientTxs.append(txs[i]);
                return txs[i];
            }
        }
    }
}