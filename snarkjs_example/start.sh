#!/bin/bash

# Start a new powers of tau ceremony
echo "Starting a new powers of tau ceremony..."
snarkjs powersoftau new bn128 14 pot14_0000.ptau -v
sleep 5

# Contribute to the ceremony
echo "Contributing to the ceremony (First contribution)..."
snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First contribution" -v
sleep 5

# Provide a second contribution
echo "Contributing to the ceremony (Second contribution)..."
snarkjs powersoftau contribute pot14_0001.ptau pot14_0002.ptau --name="Second contribution" -v -e="some random text"
sleep 5

# Provide a third contribution using third-party software
echo "Providing third contribution using third-party software..."
snarkjs powersoftau export challenge pot14_0002.ptau challenge_0003
sleep 5
snarkjs powersoftau challenge contribute bn128 challenge_0003 response_0003 -e="some random text"
sleep 5
snarkjs powersoftau import response pot14_0002.ptau response_0003 pot14_0003.ptau -n="Third contribution name"
sleep 5

# Verify the protocol so far
echo "Verifying the protocol so far..."
snarkjs powersoftau verify pot14_0003.ptau
sleep 5

# Apply a random beacon
echo "Applying a random beacon..."
snarkjs powersoftau beacon pot14_0003.ptau pot14_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
sleep 5

# Prepare phase 2
echo "Preparing phase 2..."
snarkjs powersoftau prepare phase2 pot14_beacon.ptau pot14_final.ptau -v
sleep 5

# Verify the final ptau
echo "Verifying the final ptau..."
snarkjs powersoftau verify pot14_final.ptau
sleep 5

echo "Powers of tau ceremony completed!"
chmod +x powersoftau.sh
