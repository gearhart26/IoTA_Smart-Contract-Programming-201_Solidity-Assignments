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

//        adding a new mapping to keep track of how many tokens each address ownes to speed up getAllCatsFor function and improve storage design
    mapping (address => uint256[]) public tokensOwned;
    
    mapping (uint256 => address) public kittyIndexToOwner;
    mapping (address => uint256) ownershipTokenCount;

    

    function balanceOf(address owner) external view returns (uint256 balance){
        return ownershipTokenCount[owner];
    }

    function totalSupply() public view returns (uint) {
        return kitties.length;
    }

    function ownerOf(uint256 _tokenId) external view returns (address)
    {
        return kittyIndexToOwner[_tokenId];
    }

    function transfer(address _to,uint256 _tokenId) external
    {
        require(_to != address(0));
        require(_to != address(this));
        require(_owns(msg.sender, _tokenId));

        _transfer(msg.sender, _to, _tokenId);
    }
    
//        change getAllCatsFor function to simply return value stored in mapping instead of looping through entire array
    function getAllCatsFor(address _owner) external view returns (uint[] memory cats){
        return tokensOwned[_owner];
    }
        //uint[] memory result = new uint[](ownershipTokenCount[_owner]);
        //uint counter = 0;
        //for (uint i = 0; i < kitties.length; i++) {
            //if (kittyIndexToOwner[i] == _owner) {
                //result[counter] = i;
                //counter++;
            //}
        //}
        //return result;
     //}
    
    function createKittyGen0(uint256 _genes) public returns (uint256) {
        return _createKitty(0, 0, 0, _genes, msg.sender);
    }

    function _createKitty(
        uint256 _mumId,
        uint256 _dadId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    ) private returns (uint256) {
        Kitty memory _kitty = Kitty({
            genes: _genes,
            birthTime: uint64(block.timestamp),
            mumId: uint32(_mumId),
            dadId: uint32(_dadId),
            generation: uint16(_generation)
        });
        
        kitties.push(_kitty);

        uint256 newKittenId = kitties.length - 1;

        emit Birth(_owner, newKittenId, _mumId, _dadId, _genes);

        _transfer(address(0), _owner, newKittenId);

        return newKittenId;

    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        ownershipTokenCount[_to]++;
        kittyIndexToOwner[_tokenId] = _to;
//            adding token Id to tokensOwned mapping for recieving address
        tokensOwned[_to].push(_tokenId);
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
//                calling _changeOwner function to remove token Id from senders tokensOwned mapping
            _changeOwner(_from, _tokenId);
        }
        emit Transfer(_from, _to, _tokenId);
    }

//        function needed to remove token Ids from new mapping as tokens are transfered.
//        using same idea as storage design example : mapping_w_Index_and_Delete.sol
    function _changeOwner(address _from, uint _tokenId) internal {
        uint tokenIdToMove = tokensOwned[_from][tokensOwned[_from].length-1];
        for (uint i = 0; i < tokensOwned[_from].length; i++) {
            if (tokensOwned[_from][i] == _tokenId) {
                tokensOwned[_from][i] == tokenIdToMove;
                tokensOwned[_from].pop();
            }
        }
    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
      return kittyIndexToOwner[_tokenId] == _claimant;
  }

}
