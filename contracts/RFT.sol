// Refungible Token Contract // 
pragma solidity ^0.7.2;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

contract RFT is ERC20 {
  uint public icoSharePrice;
  uint public icoShareSupply;
  uint public icoEnd;
  uint public nftId;

  IERC721 public nft;
  IERC20 public dai;

  address public admin;

  constructor(
    string memory _name,
    string memory _symbol,
    uint _nftId,
    uint _icoSharePrice,
    uint _icoShareSupply,
    address _daiAddress,
    address _nftAddress
  )
  ERC20(_name, _symbol) {
    nftId = _nftId;
    icoSharePrice = _icoSharePrice;
    icoShareSupply = _icoShareSupply;
    dai = IERC20(_daiAddress);
    nft = IERC721(_nftAddress);
    admin = msg.sender;
  }

  modifier onlyAdmin() {
        require(msg.sender == admin, "Solo el admin puede ejecutar la funcion");
        _;
    }

  function startIco() external onlyAdmin {
    nft.trasferFrom(msg.sender, address(this), nftId);
    icoEnd = block.timestamp + 7 * 86400;
  }

  function buyShare(uint shareAmount) external {
    require(icoEnd > 0, 'El ICO no ha comenzado aun');
    require(block.timestamp <= icoEnd, 'El ICO ha finalizado');
    require(totalSupply() + shareAmount <= icoShareSupply, 'No hay suficientes tokens');
    uint daiAmount = shareAmount * icoSharePrice;
    dai.trasferFrom(msg.sender, address(this), daiAmount);
    // _mint from erc20.sol
    _mint(msg.sender, shareAmount);
  }

  function withdrawIcoProfits() external onlyAdmin {
    
  }
}