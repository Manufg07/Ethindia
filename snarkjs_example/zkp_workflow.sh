#!/bin/bash

# Setup the circuit
snarkjs groth16 setup circuit.r1cs pot14_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_final.zkey --name="1st Contributor" -v
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# Generate proof
snarkjs groth16 fullprove input.json circuit.wasm circuit_final.zkey proof.json public.json
echo "Generated proof and public signals."

# Verify proof
snarkjs groth16 verify verification_key.json public.json proof.json
echo "Proof verification completed."
