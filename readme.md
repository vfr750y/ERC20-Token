# OurToken Solidity Project

This project implements a simple ERC20 token called "OurToken" (symbol: OT) using Solidity, along with deployment scripts and comprehensive tests. The project is built with Foundry, a powerful Solidity development framework, and includes a Makefile for streamlined development and deployment workflows.

## Table of Contents
- [Project Overview](#project-overview)
- [File Structure](#file-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Building the Project](#building-the-project)
  - [Running Tests](#running-tests)
  - [Deploying the Contract](#deploying-the-contract)
  - [Formatting and Snapshots](#formatting-and-snapshots)
- [Contract Details](#contract-details)
  - [OurToken.sol](#ourtoken.sol)
  - [DeployOurToken.s.sol](#deployourtoken.s.sol)
  - [OurTokenTest.t.sol](#ourtokentest.t.sol)
- [Testing](#testing)
- [Makefile Commands](#makefile-commands)
- [Environment Variables](#environment-variables)
- [License](#license)

## Project Overview
The project creates an ERC20-compliant token called `OurToken` with a fixed initial supply of 100 ether (100 OT). It leverages OpenZeppelin's ERC20 implementation for standard token functionality. The project includes:
- A deployment script to deploy the token contract.
- A comprehensive test suite to verify token behavior.
- A Makefile for managing build, test, and deployment tasks.
- Support for deployment on Ethereum-compatible networks (e.g., Anvil, Sepolia) and zkSync networks.

## File Structure
```
├── src/
│   └── OurToken.sol          # ERC20 token contract
├── script/
│   └── DeployOurToken.s.sol  # Deployment script
├── test/
│   └── OurTokenTest.t.sol    # Test suite for the token contract
├── Makefile                  # Development and deployment tasks
└── README.md                 # Project documentation
```

## Prerequisites
To work with this project, ensure you have the following installed:
- [Foundry](https://getfoundry.sh/) (includes `forge`, `cast`, and `anvil`)
- [Node.js](https://nodejs.org/) (for dependency management, if needed)
- [Make](https://www.gnu.org/software/make/) (for running Makefile commands)
- A `.env` file with environment variables (see [Environment Variables](#environment-variables))

Optional for zkSync deployment:
- [foundry-zksync](https://github.com/matter-labs/foundry-zksync) for zkSync support

## Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```
2. Install dependencies using the Makefile:
   ```bash
   make install
   ```
   This installs:
   - `cyfrin/foundry-devops@0.2.2`
   - `foundry-rs/forge-std@v1.8.2`
   - `openzeppelin/openzeppelin-contracts@v5.0.2`

3. Set up environment variables in a `.env` file (see [Environment Variables](#environment-variables)).

## Usage

### Building the Project
Compile the smart contracts:
```bash
make build
```

### Running Tests
Run the test suite:
```bash
make test
```
For zkSync-specific tests:
```bash
make test-zk
```

### Deploying the Contract
- **Local Development (Anvil)**:
  Start a local Anvil node:
  ```bash
  make anvil
  ```
  Deploy to the local Anvil node:
  ```bash
  make deploy
  ```

- **Sepolia Testnet**:
  Ensure `.env` contains `SEPOLIA_RPC_URL`, `ACCOUNT`, `SENDER`, and `ETHERSCAN_API_KEY`. Then deploy:
  ```bash
  make deploy-sepolia
  ```

- **zkSync Local Node**:
  Deploy to a local zkSync node:
  ```bash
  make deploy-zk
  ```

- **zkSync Sepolia Testnet**:
  Ensure `.env` contains `ZKSYNC_SEPOLIA_RPC_URL` and `ACCOUNT`. Then deploy:
  ```bash
  make deploy-zk-sepolia
  ```

### Formatting and Snapshots
- Format code:
  ```bash
  make format
  ```
- Create a gas snapshot:
  ```bash
  make snapshot
  ```

## Contract Details

### OurToken.sol
The main contract implementing the ERC20 token:
- **Inherits**: OpenZeppelin's `ERC20` contract.
- **Constructor**: Mints an `initialSupply` of tokens to the deployer's address.
- **Token Metadata**:
  - Name: `OurToken`
  - Symbol: `OT`
  - Decimals: 18 (standard for ERC20 tokens)

### DeployOurToken.s.sol
A Foundry script to deploy the `OurToken` contract:
- **Initial Supply**: 100 ether (100 OT).
- **Functionality**: Deploys the contract using the `vm.startBroadcast()` and `vm.stopBroadcast()` pattern for secure deployment.

### OurTokenTest.t.sol
A comprehensive test suite for the `OurToken` contract, covering:
1. **Bob's Balance**: Verifies Bob receives the starting balance after setup.
2. **Token Metadata**: Checks token name, symbol, and decimals.
3. **Total Supply**: Ensures the total supply matches the initial supply.
4. **Initial Supply to Deployer**: Verifies the deployer's balance after transferring to Bob.
5. **Direct Transfer**: Tests successful token transfers.
6. **Insufficient Balance Transfer**: Ensures transfers fail with insufficient balance.
7. **Allowances**: Tests the `approve` and `transferFrom` functions.
8. **Insufficient Allowance**: Ensures `transferFrom` fails with insufficient allowance.
9. **Zero Address Transfer**: Ensures transfers to the zero address fail.
10. **Zero Address TransferFrom**: Ensures `transferFrom` to the zero address fails.
11. **Approval Event**: Verifies the `Approval` event is emitted correctly.
12. **Transfer Event**: Verifies the `Transfer` event is emitted correctly.
13. **Multiple Approvals**: Tests updating allowances for the same spender.
14. **Deploy Script**: Verifies the deployment script deploys the contract correctly.
15. **Zero Amount Transfer**: Tests transfers of zero tokens.

## Testing
The test suite uses Foundry's `forge-std/Test.sol` for testing utilities and `vm.prank` for simulating transactions from different addresses. Key features tested include:
- Token metadata (name, symbol, decimals)
- Token transfers and allowances
- Edge cases like insufficient balance, zero address, and zero-amount transfers
- Event emissions for `Transfer` and `Approval`

To run tests:
```bash
make test
```

For zkSync:
```bash
make test-zk
```

## Makefile Commands
The `Makefile` provides the following commands:
- `make all`: Cleans, removes modules, installs dependencies, updates, and builds.
- `make clean`: Removes compiled artifacts.
- `make remove`: Removes git submodules and related files.
- `make install`: Installs dependencies.
- `make update`: Updates dependencies.
- `make build`: Compiles the contracts.
- `make test`: Runs the test suite.
- `make test-zk`: Runs tests with zkSync compiler.
- `make snapshot`: Creates a gas snapshot.
- `make format`: Formats the codebase.
- `make anvil`: Starts a local Anvil node.
- `make deploy`: Deploys to a local Anvil node.
- `make deploy-sepolia`: Deploys to Sepolia testnet.
- `make deploy-zk`: Deploys to a local zkSync node.
- `make deploy-zk-sepolia`: Deploys to zkSync Sepolia testnet.

## Environment Variables
Create a `.env` file in the root directory with the following variables for testnet deployments:
```bash
SEPOLIA_RPC_URL=<your-sepolia-rpc-url>
ZKSYNC_SEPOLIA_RPC_URL=<your-zksync-sepolia-rpc-url>
ACCOUNT=<your-account-name>
SENDER=<your-sender-address>
ETHERSCAN_API_KEY=<your-etherscan-api-key>
PRIVATE_KEY=<your-private-key>  # Optional for some deployments
```

Example `.env`:
```bash
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your-api-key
ZKSYNC_SEPOLIA_RPC_URL=https://sepolia.era.zksync.dev
ACCOUNT=default
SENDER=0xYourAddress
ETHERSCAN_API_KEY=your-etherscan-key
```

## License
This project is licensed under the MIT License. See the SPDX-License-Identifier in each file for details.