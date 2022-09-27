/* global describe it before ethers */

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
  } = require('../scripts/libraries/diamond.js')
  
  const { deployDiamond } = require('../scripts/deploy.js')
  
  const { assert, expect } = require('chai');
const { ethers } = require('hardhat');
  
  describe('DiamondTest', async function () {
    let diamondAddress;
    let diamondCutFacet;
    let diamondLoupeFacet;
    let ownershipFacet
    let ERC20;
    let tx;
    let receipt;
    let result;
    const addresses = []
  
    before(async function () {
      diamondAddress = await deployDiamond();
      diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress);
      diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress);
      ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress);
      ERC20 = await ethers.getContractAt("ERC20", diamondAddress);
    })
  
    it('Testing balanceof', async () => {
        const [signer] = await ethers.getSigners();
       let bal = ERC20.balanceOf(signer.address);
       console.log(bal);
    })

})


  