const { expect } = require('chai')
const { ethers } = require('hardhat')
const { utils } = ethers

const NAME = "TokenMaster"
const SYMBOL = "TM"

const OCCASION_NAME ='ETH Nairobi'
const OCCASION_COST = ethers.parseUnits('1', 'ether')
const OCCASION_MAX_TICKETS = 100
const OCCASION_DATE = "Apr 27"
const OCCASION_TIME = "10:00AM CAT"
const OCCASION_LOCATION = "Nairobi, Kenya"


describe("TokenMaster", () => {
    let tokenMaster
    let deployer, buyer

    beforeEach(async () => {
        [deployer, buyer] = await ethers.getSigners()

        const TokenMaster = await ethers.getContractFactory("TokenMaster")
        tokenMaster = await TokenMaster.deploy(NAME, SYMBOL)

        const transaction = await tokenMaster.connect(deployer).list(
            OCCASION_NAME,
            OCCASION_COST,
            OCCASION_MAX_TICKETS,
            OCCASION_DATE,
            OCCASION_TIME,
            OCCASION_LOCATION

        )
        
        await transaction.wait()
    })

    describe("Deployment", () => {
        it("Sets the name", async () => {
            expect(await tokenMaster.name()).to.equal(NAME)
        })

        it("Sets the symbol", async () => {
            expect(await tokenMaster.symbol()).to.equal(SYMBOL)

        })

        it("Sets the owner", async () => {
            expect(await tokenMaster.owner()).to.equal(deployer.address)
        })
    })

    describe("Deployment", () => {

    })

    describe("Occasions", () => {
        it('Updates occasions count', async () => {
            const totalOccasions = await tokenMaster.totalOccasions();
            expect(totalOccasions).to.be.equal(1)
        })
    })
    
    describe("Paid tickets", () => {
         
    })
})