#!/bin/bash
echo "Starting Powers of Tau..."
snarkjs powersoftau new bn128 14 pot14_0000.ptau -v
snarkjs powersoftau contribute pot14_0000.ptau pot14_final.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot14_final.ptau pot14_final.ptau -v
echo "Powers of Tau ceremony completed!"
