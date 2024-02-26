import { useState, useEffect } from "react";
import { ethers } from "ethers";
import atm_abi from "../artifacts/contracts/Assessment.sol/Assessment.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [atm, setATM] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [totalDeposits, setTotalDeposits] = useState(undefined);
  const [totalWithdrawals, setTotalWithdrawals] = useState(undefined);

  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const atmABI = atm_abi.abi;

  const getWallet = async () => {
    try {
      if (window.ethereum) {
        setEthWallet(window.ethereum);
      }

      if (ethWallet) {
        const accounts = await ethWallet.request({ method: "eth_accounts" });
        handleAccount(accounts);
      }
    } catch (error) {
      console.error("Error getting wallet:", error);
    }
  };

  const handleAccount = (accounts) => {
    try {
      if (accounts.length > 0) {
        console.log("Account connected:", accounts[0]);
        setAccount(accounts[0]);
      } else {
        console.log("No account found");
      }
    } catch (error) {
      console.error("Error handling account:", error);
    }
  };

  const connectAccount = async () => {
    try {
      if (!ethWallet) {
        alert("MetaMask wallet is required to connect");
        return;
      }

      const accounts = await ethWallet.request({
        method: "eth_requestAccounts",
      });
      handleAccount(accounts);

      // once the wallet is set, we can get a reference to our deployed contract
      getATMContract();
    } catch (error) {
      console.error("Error connecting account:", error);
    }
  };

  const getATMContract = () => {
    try {
      const provider = new ethers.providers.Web3Provider(ethWallet);
      const signer = provider.getSigner();
      const atmContract = new ethers.Contract(
        contractAddress,
        atmABI,
        signer
      );

      setATM(atmContract);
    } catch (error) {
      console.error("Error getting ATM contract:", error);
    }
  };

  const getBalance = async () => {
    try {
      if (atm) {
        setBalance((await atm.getBalance()).toNumber());
      }
    } catch (error) {
      console.error("Error getting balance:", error);
    }
  };

  const getTotalTransactions = async () => {
    try {
      if (atm) {
        const [deposits, withdrawals] = await atm.getTotalTransactions();
        setTotalDeposits(deposits.toNumber());
        setTotalWithdrawals(withdrawals.toNumber());
      }
    } catch (error) {
      console.error("Error getting total transactions:", error);
    }
  };

  const deposit = async () => {
    try {
      if (atm) {
        let tx = await atm.deposit(1);
        await tx.wait();
        getBalance();
        getTotalTransactions();
      }
    } catch (error) {
      console.error("Error depositing:", error);
    }
  };

  const withdraw = async () => {
    try {
      if (atm) {
        let tx = await atm.withdraw(1);
        await tx.wait();
        getBalance();
        getTotalTransactions();
      }
    } catch (error) {
      console.error("Error withdrawing:", error);
    }
  };

  const initUser = () => {
    try {
      // Check if the user has Metamask
      if (!ethWallet) {
        return <p>Please install Metamask to use this ATM.</p>;
      }

      // Check if the user is connected. If not, connect to their account
      if (!account) {
        return (
          <div>
            <button style={styles.button} onClick={connectAccount}>
              Please connect your Metamask wallet
            </button>
          </div>
        );
      }

      if (
        balance === undefined ||
        totalDeposits === undefined ||
        totalWithdrawals === undefined
      ) {
        getBalance();
        getTotalTransactions();
      }

      return (
        <div style={styles.container}>
          <p style={styles.text}>Your Account: {account}</p>
          <p style={styles.text}>Your Balance: {balance}</p>
          <p style={styles.text}>Total Deposits: {totalDeposits}</p>
          <p style={styles.text}>Total Withdrawals: {totalWithdrawals}</p>
          <button style={styles.button} onClick={deposit}>
            Deposit 1 ETH
          </button>
          <button style={styles.button} onClick={withdraw}>
            Withdraw 1 ETH
          </button>
        </div>
      );
    } catch (error) {
      console.error("Error initializing user:", error);
    }
  };

  useEffect(() => {
    getWallet();
  }, []);

  return (
    <main style={styles.main}>
      <header>
        <h1 style={styles.heading}>Welcome to the Metacrafters ATM!</h1>
      </header>
      {initUser()}
    </main>
  );
}

const styles = {
  main: {
    textAlign: "center",
    backgroundColor: "lightblue",
    padding: "20px",
    color: "white",
  },
  heading: {
    color: "white",
  },
  container: {
    marginTop: "20px",
  },
  text: {
    color: "#555",
    fontSize: "18px",
    marginBottom: "5px",
  },
  button: {
    backgroundColor: "lightpink",
    color: "grey",
    padding: "10px",
    margin: "5px",
    cursor: "pointer",
  },
};
