/**
 *Submitted for verification at BscScan.com on 2022-04-17
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.6;


interface IERC20 {
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Ownable {
    address public _owner;

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function changeOwner(address newOwner) public onlyOwner {
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

contract MT is IERC20, Ownable {
    using SafeMath for uint256;

    // get balance
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;

    mapping(address => mapping(address => uint256)) private _allowances;
    // no fee.
    mapping(address => bool) private _isExcludedFromFee;

    // custom limit amount percent
    mapping(address => bool) private _isCustomLimitAmount;
    mapping(address => uint256) private _customLimitAmountPercent;
    uint256 public _limitAmountPercent;

    // custom other fee
    mapping(address => bool) private _isCustomOtherFee;
    mapping(address => uint256) private _customOtherFee;


    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 public _tTotalFeeMax;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;
    string private _name;
    string private _symbol;
    uint256 private _decimals;

    // for fees.
    uint256 public _feeBuyBonus;
    uint256 public _feeBuyFund;
    uint256 public _feeBuyDestroy;

    uint256 public _feeSellBonus;
    uint256 public _feeSellFund;
    uint256 public _feeSellDestroy;
    // fee to other
    uint256 public _feeOther;
    // free for pool locker
    uint256 public _feeFromPoolLockerTechnical; // for Technical
    uint256 public _feeFromPoolLockerFund;// for fund

    address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);

    /** addresses for online **/
    address public _mainAddress = address(0x54952f727806E98E5Cbf60d245031f2D417554d7);// main address.
    address public _technicalAddress = address(0x2b2fB8d736E318059F1A572eb910dF60efd4bFb3);// technical address.
    address public _bonusAddress = address(0x7c355082bDB119b5a885754cD6917787419E4267);// bonus address.
    address public _fundAddress = address(0x1458B095CcfCd325d70BC1f231A438A622EEae09);// fund address.
    address public _otherAddress = address(0xCB9Af777C90736b5848825065E7fc9264d1D81fA);// other address
    address public _minerAddress = address(0xCD3Ea18cdea3FEb5eF1Ae8b77E2b03Cd6CAaBc6b);// miner address
    address public _withdrawalAddress = address(0xe2766532B511265227368035DcdE85dCBDF59F74);// withdrawal address
    /** addresses for online **/

    // pair
    address public uniswapV2Pair;
    // the pool locker contract address
    address public poolLocker;

    constructor(address tokenOwner) {
        _name = "LITTLE BEE";
        _symbol = "LB";
        _decimals = 18;

        // fees
        _feeBuyBonus = 3; // buy fee send to Bonus address
        _feeBuyFund = 1; // buy fee send to fund address
        _feeBuyDestroy = 1;// buy fee send to destroy address

        _feeSellBonus = 3;// sell fee send to Bonus address
        _feeSellFund = 1;// sell fee send to fund address
        _feeSellDestroy = 1;// sell fee send to destroy address

        _feeOther = 7; // transfer fee by send to other address

        // for pool locker
        _feeFromPoolLockerTechnical = 1; // transfer fee by send from pool locker
        _feeFromPoolLockerFund = 1; // transfer fee by send from pool locker

        // total supply
        _tTotal = 2100000 * 10**_decimals;
        // at least 1 leave
        uint256 leaveAmount = 1 * 10**_decimals;
        _tTotalFeeMax = _tTotal.sub(leaveAmount);
        _rTotal = (MAX - (MAX % _tTotal));
        _rOwned[tokenOwner] = _rTotal;


        // set excluded from fee address
        _isExcludedFromFee[tokenOwner] = true;
        _isExcludedFromFee[_mainAddress] = true;
        _isExcludedFromFee[_technicalAddress] = true;
        _isExcludedFromFee[_bonusAddress] = true;
        _isExcludedFromFee[_fundAddress] = true;
        _isExcludedFromFee[_otherAddress] = true;

        // default set _withdrawalAddress fee to other 5%
        _isCustomOtherFee[_withdrawalAddress] = true;
        _customOtherFee[_withdrawalAddress] = 5;

        // set limit amount
        _limitAmountPercent = 90; // the max percent of transfer amount by balance
        // set default limit amount, set limit amount percent = 100 , means no  limit
       _isCustomLimitAmount[_mainAddress] = true;
       _isCustomLimitAmount[_technicalAddress] = true;
       _isCustomLimitAmount[_bonusAddress] = true;
       _isCustomLimitAmount[_fundAddress] = true;
       _isCustomLimitAmount[_otherAddress] = true;
       _isCustomLimitAmount[_minerAddress] = true;
       _isCustomLimitAmount[_withdrawalAddress] = true;
       _isCustomLimitAmount[tokenOwner] = true;

       _customLimitAmountPercent[_mainAddress] = 100;
       _customLimitAmountPercent[_technicalAddress] = 100;
       _customLimitAmountPercent[_bonusAddress] = 100;
       _customLimitAmountPercent[_fundAddress] = 100;
       _customLimitAmountPercent[_otherAddress] = 100;
       _customLimitAmountPercent[_minerAddress] = 100;
       _customLimitAmountPercent[_withdrawalAddress] = 100;
       _customLimitAmountPercent[tokenOwner] = 100;

        // _owner = msg.sender;
        _owner = tokenOwner; //  tokenOwner is the owner
        emit Transfer(address(0), tokenOwner, _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
		if(uniswapV2Pair == address(0) && amount >= _tTotal.div(100)){
			uniswapV2Pair = recipient;
		}
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    // custom other fee for address,and set use custom fee or not
    function customOtherFee(bool useCustomBool , address account , uint256 fee ) public onlyOwner {
        if(useCustomBool){
            _isCustomOtherFee[account] = true;
            _customOtherFee[account] = fee;
        }else{
            _isCustomOtherFee[account] = false;
            _customOtherFee[account] = fee;
        }
    }

    // get the other fee of address
    function getOtherFeeOfAddress(address account) public view returns (uint256) {
        if(_isExcludedFromFee[account]){
            return 0;
        }
        if(_isCustomOtherFee[account]){
            return _customOtherFee[account];
        }
        return _feeOther;
    }

    // custom limit amount for address,and set use limit amount or not
    function customLimitAmountPercent(bool useCustomBool , address account , uint256 limitPercent ) public onlyOwner {
        if(useCustomBool){
            _isCustomLimitAmount[account] = true;
            _customLimitAmountPercent[account] = limitPercent;
        }else{
            _isCustomLimitAmount[account] = false;
            _customLimitAmountPercent[account] = limitPercent;
        }
    }

    // get the limit amount percent of address
    function getLimitAmountPercentOfAddress(address account) public view returns (uint256) {
        if(_isCustomLimitAmount[account]){
            return _customLimitAmountPercent[account];
        }
        return _limitAmountPercent;
    }

    // to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    // rSupply/tSupply
    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        // check amount limit
        uint256 limitAmountPercent = getLimitAmountPercentOfAddress(from);
        if( limitAmountPercent < 100 ){
            // limit
            uint256 maxLimitAmount = balanceOf(from).div(100).mul(limitAmountPercent);
            require(amount <= maxLimitAmount , "Transfer amount must be less than _limitAmountPercent % of balance");
        }

        // the destroy amount in _destroyAddress
		uint256 destroyAmount = balanceOf(_destroyAddress);

        if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || destroyAmount >= _tTotalFeeMax){
            // ExcludedFromFee or the last is so small;
            // send free;
            _tokenTransfer(from, to, amount, false);
        }else{
			if(from == uniswapV2Pair){
				_tokenTransferBuy(from, to, amount, true);
			}else if(to == uniswapV2Pair){
                _tokenTransferSell(from, to, amount, true);
            }else if( from == poolLocker ){
                // unlock
                _tokenTransferFromPoolLocker(from, to, amount, true);
            }else{
                // when send to other address, need transfer fee
                _tokenTransferOther(from, to, amount, true);
            }
        }
    }

    // send to other address but not free
    function _tokenTransferOther(
            address sender,
            address recipient,
            uint256 tAmount,
            bool takeFee
    ) private {
        uint256 currentRate = _getRate();
        // with fee Rate.
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        uint256 rate;
        if (takeFee) {
            // when transfer to other address,need other fee
            uint256 senderOtherFee = getOtherFeeOfAddress(sender);
            if(senderOtherFee > 0){
                _takeTransfer(
                    sender,
                    _otherAddress,
                    tAmount.div(100).mul(senderOtherFee),
                    currentRate
                );
            }

            // total fee
            rate = senderOtherFee;
        }
        uint256 recipientRate = 100 - rate;
        // get real amount , delete fee.
        // never be defined;
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(100).mul(recipientRate)
        );
        emit Transfer(sender, recipient, tAmount.div(100).mul(recipientRate));
    }

    function _tokenTransferSell(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        uint256 currentRate = _getRate();
        // with fee Rate.
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        uint256 rate;
        if (takeFee) {
            // when sell,fee to fund address.
             if(_feeSellBonus > 0){
                _takeTransfer(
                    sender,
                    _bonusAddress,
                    tAmount.div(100).mul(_feeSellBonus),
                    currentRate
                );
            }
            if(_feeSellFund > 0){
                _takeTransfer(
                    sender,
                    _fundAddress,
                    tAmount.div(100).mul(_feeSellFund),
                    currentRate
                );
            }

            if(_feeSellDestroy > 0){
                // when sell,fee to destroy address.
                _takeTransfer(
                     sender,
                     _destroyAddress,
                     tAmount.div(100).mul(_feeSellDestroy),
                     currentRate
                );
            }

            // total sell fee
            rate = _feeSellFund + _feeSellDestroy + _feeSellBonus;
        }
        uint256 recipientRate = 100 - rate;
        // get real amount , delete fee.
        // never be defined;
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(100).mul(recipientRate)
        );
        emit Transfer(sender, recipient, tAmount.div(100).mul(recipientRate));
    }

    function _tokenTransferBuy(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        uint256 rate;
        if (takeFee) {
            // buy fee
            if(_feeBuyBonus > 0){
                _takeTransfer(
                    sender,
                    _bonusAddress,
                    tAmount.div(100).mul(_feeBuyBonus),
                    currentRate
                );
            }

            if(_feeBuyFund > 0){
                _takeTransfer(
                    sender,
                    _fundAddress,
                    tAmount.div(100).mul(_feeBuyFund),
                    currentRate
                );
            }

            if(_feeBuyDestroy > 0){
                // when buy,fee to destroy address.
                _takeTransfer(
                     sender,
                     _destroyAddress,
                     tAmount.div(100).mul(_feeBuyDestroy),
                     currentRate
                );
            }

            rate = _feeBuyFund + _feeBuyDestroy + _feeBuyBonus;
        }
        uint256 recipientRate = 100 - rate;
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(100).mul(recipientRate)
        );
        emit Transfer(sender, recipient, tAmount.div(100).mul(recipientRate));
    }

    // get from pool locker
    function _tokenTransferFromPoolLocker(
            address sender,
            address recipient,
            uint256 tAmount,
            bool takeFee
        ) private {
        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        uint256 rate;
        if (takeFee) {
            // Technical fee
            if(_feeFromPoolLockerTechnical > 0){
                _takeTransfer(
                    sender,
                    _technicalAddress,
                    tAmount.div(100).mul(_feeFromPoolLockerTechnical),
                    currentRate
                );
            }

            // Fund fee
            if(_feeFromPoolLockerFund > 0){
                _takeTransfer(
                    sender,
                    _fundAddress,
                    tAmount.div(100).mul(_feeFromPoolLockerFund),
                    currentRate
                );
            }

            rate = _feeFromPoolLockerFund + _feeFromPoolLockerTechnical;
        }
        uint256 recipientRate = 100 - rate;
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(100).mul(recipientRate)
        );
        emit Transfer(sender, recipient, tAmount.div(100).mul(recipientRate));
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        uint256 rate;
        if (takeFee) {
            rate = 0;
        }
        uint256 recipientRate = 100 - rate;
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(100).mul(recipientRate)
        );
        emit Transfer(sender, recipient, tAmount.div(100).mul(recipientRate));
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[to] = _rOwned[to].add(rAmount);
        emit Transfer(sender, to, tAmount);
    }

    function changeRouter(address router) public onlyOwner {
        uniswapV2Pair = router;
    }

    // change the pool locker address
    function changePoolLocker(address locker) public onlyOwner {
        poolLocker = locker;
    }

    /* change system address */
    function changeMainAddress(address addr) public onlyOwner {
        _mainAddress = addr;
    }
    function changeTechnicalAddress(address addr) public onlyOwner {
        _technicalAddress = addr;
    }
    function changeBonusAddress(address addr) public onlyOwner {
        _bonusAddress = addr;
    }
    function changeFundAddress(address addr) public onlyOwner {
        _fundAddress = addr;
    }
    function changeOtherAddress(address addr) public onlyOwner {
        _otherAddress = addr;
    }
    function changeMinerAddress(address addr) public onlyOwner {
        _minerAddress = addr;
    }
    function changeWithdrawalAddress(address addr) public onlyOwner {
        _withdrawalAddress = addr;
    }
    /* /change system address */

    function setFeeBuyBonus(uint256 fee) public onlyOwner {
         _feeBuyBonus = fee;
    }

    function setFeeBuyFund(uint256 fee) public onlyOwner {
         _feeBuyFund = fee;
    }

    function setFeeBuyDestroy(uint256 fee) public onlyOwner {
         _feeBuyDestroy = fee;
    }

    function setFeeSellBonus(uint256 fee) public onlyOwner {
        _feeSellBonus = fee;
    }

    function setFeeSellFund(uint256 fee) public onlyOwner {
         _feeSellFund = fee;
    }

    function setFeeSellDestroy(uint256 fee) public onlyOwner {
         _feeSellDestroy = fee;
    }

    function setFeeOther(uint256 fee) public onlyOwner {
         _feeOther = fee;
    }

    function setFeeFromPoolLockerTechnical(uint256 fee) public onlyOwner {
        _feeFromPoolLockerTechnical = fee;
    }

    function setFeeFromPoolLockerFund(uint256 fee) public onlyOwner {
        _feeFromPoolLockerFund = fee;
    }

    // set default limit amount percent
    function setLimitAmountPercent(uint256 percent) public onlyOwner {
        _limitAmountPercent = percent;
    }



}