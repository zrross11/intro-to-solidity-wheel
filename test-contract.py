from web3 import Web3
import json
from datetime import datetime

def test_contract():
    """
    This function performs a test transaction on the local development chain and reads the state of the contract.

    It connects to the local Ethereum node, unlocks the account to send transactions, loads the contract ABI,
    gets the contract address, calls the contract function to make a decision, signs and sends the transaction,
    waits for the transaction to be mined, and finally retrieves the decisions from the contract.

    Returns:
        None
    """
    # Connect to the local Ethereum node
    w3 = Web3(Web3.HTTPProvider('http://localhost:7545'))

    # Check if the connection is successful
    if w3.is_connected():
        print('Connected to the local Ethereum node')

        # Unlock the account to send transactions
        w3.eth.defaultAccount = w3.eth.accounts[0]

        # Load the contract ABI
        with open('build/contracts/DecisionWheel.json', 'r') as abi_definition:
            abi = json.load(abi_definition)['abi']

        # Get the contract address
        # Update this after deploying the contract
        contract_address = '0xC87e67eDD8B4066B762422437A3cE24231637382'

        contract = w3.eth.contract(address=contract_address, abi=abi)

        # Call the contract function
        # Params are a string for the question and a list of strings for the options 
        transaction = contract.functions.makeDecision('What should I eat for dinner?', ['Pizza', 'Sushi', 'Burger']).build_transaction({
            'from': w3.eth.defaultAccount,
            'nonce': w3.eth.get_transaction_count(w3.eth.defaultAccount),
            'gas': 70000
        })
        
        # Sign the transaction
        signed_txn = w3.eth.account.sign_transaction(transaction, '0x08b95df9961a69021e5ef086f4cbf4613e68eac0ede8ecbf0136c62949f2843a')

        # Send the transaction
        txn_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

        # Wait for the transaction to be mined, and get the transaction receipt
        txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)

        # Call the contract function to return the 5 decisions from on chain
        decisions = contract.functions.getDecisions().call()

        for decision in decisions:
            # Convert Unix timestamp to readable date
            date = decision[-1]
            date = datetime.fromtimestamp(date).strftime('%Y-%m-%d %H:%M:%S')

            print(f'Prompt: {decision[0]}, Choice: {decision[1]}, Date: {date}, Sender: {decision[2]}')
   
    else:
        print('Failed to connect to the local Ethereum node')

if __name__ == '__main__':
    test_contract()