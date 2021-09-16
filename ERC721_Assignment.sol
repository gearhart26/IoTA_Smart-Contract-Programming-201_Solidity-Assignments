// topic = Token Standards --> video = Assignment – ERC721 //

// ERC721 Token assignment for Ethereum Smart Contract Programming 201


// 1.  **What is the time complexity of creating new cats?**
// The time complexity of creating new cats is constant because creating mappings and adding a new element to an array are quick 
// operations that do not depend on storage size or looping through an ever expanding array. 

// 2. **What is the time complexity of the getAllCatsFor function?**
// The getAllCatsFor function, however, has a time complexity that grows linearly with the number of cats stored in the array.  
// Each cat added increases the length of the array and the amount of time it takes to loop through all the values in that array.

// 3.  **How could the storage design be changed to make the getAllCats function constant? Discuss benefits and drawbacks with your implementation.**
// The storage design could be changed by adding another mapping to keep track of how many cats are owned by each address. 
// This adds complexity to our contract and increases the amount of code in our functions but the trade off is worth it. 
// In return the getAllCatsFor function no longer increases lineraly in time complexity as cats are added. Instead, it is now constant in time complexity. 


pragma solidity ^0.8.0;

contract Kittycontract {

    string public constant name = "TestKitties";
    string public constant symbol = "TK";
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Birth(
        address owner, 
        uint256 kittenId, 
        uint256 mumId, 
        uint256 dadId, 
        uint256 genes
    );

    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;
    
    }
