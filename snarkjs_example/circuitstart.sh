#!/bin/bash

# Step 10: Compile the circuit
echo "Compiling the circuit..."
circom --r1cs --wasm --c --sym --inspect circuit.circom
sleep 5

# Step 11: View information about the circuit
echo "Viewing information about the circuit..."
snarkjs r1cs info circuit.r1cs
sleep 5

# Step 12: Print the constraints
echo "Printing the constraints..."
snarkjs r1cs print circuit.r1cs circuit.sym
sleep 5

# Step 13: Export r1cs to JSON
echo "Exporting r1cs to JSON..."
snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
cat circuit.r1cs.json
sleep 5

# Step 14: Calculate the witness
echo "Calculating the witness..."
snarkjs wtns calculate circuit_js/circuit.wasm input.json witness.wtns
node circuit_js/generate_witness.js circuit_js/circuit.wasm input.json witness.wtns
snarkjs wtns check circuit.r1cs witness.wtns
sleep 5

# Step 15: Setup using Groth16
echo "Setting up using Groth16..."
snarkjs groth16 setup circuit.r1cs pot14_final.ptau circuit_0000.zkey
sleep 5

# Step 16: Contribute to the phase 2 ceremony
echo "Contributing to phase 2 (1st contribution)..."
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
sleep 5

# Step 17: Provide a second contribution
echo "Contributing to phase 2 (2nd contribution)..."
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
sleep 5

# Step 18: Provide a third contribution using third-party software
echo "Providing third contribution using third-party software..."
snarkjs zkey export bellman circuit_0002.zkey challenge_phase2_0003
sleep 5
snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text"
sleep 5
snarkjs zkey import bellman circuit_0002.zkey response_phase2_0003 circuit_0003.zkey -n="Third contribution name"
sleep 5

# Step 19: Verify the latest zkey
echo "Verifying the latest zkey..."
snarkjs zkey verify circuit.r1cs pot14_final.ptau circuit_0003.zkey
sleep 5

# Step 20: Apply a random beacon
echo "Applying a random beacon..."
snarkjs zkey beacon circuit_0003.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
sleep 5

# Step 21: Verify the final zkey
echo "Verifying the final zkey..."
snarkjs zkey verify circuit.r1cs pot14_final.ptau circuit_final.zkey
sleep 5

# Step 22: Export the verification key
echo "Exporting the verification key..."
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
sleep 5

# Step 23: Create the proof
echo "Creating the proof..."
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
sleep 5

# Step 23a: Calculate the witness and generate the proof in one step
echo "Calculating witness and generating proof in one step..."
snarkjs groth16 fullprove input.json circuit.wasm circuit_final.zkey proof.json public.json
sleep 5

# Step 24: Verify the proof
echo "Verifying the proof..."
snarkjs groth16 verify verification_key.json public.json proof.json
sleep 5

# Step 25: Turn the verifier into a smart contract
echo "Exporting the verifier to a Solidity smart contract (for onchain verification)..."
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
sleep 5

# Step 26: Simulate a verification call
echo "Simulating a verification call..."
snarkjs zkey export soliditycalldata public.json proof.json
sleep 5

echo "Circuit workflow completed!"
