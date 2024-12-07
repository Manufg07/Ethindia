const express = require('express');
const app = express();
const cors = require('cors');
const snarkjs = require('snarkjs');
const fs = require('fs');

app.use(cors());
app.use(express.json()); 

app.get('/read-file', async (req, res) => {
    const { proof, publicSignals } = await snarkjs.groth16.fullProve(
        { age: 9, min_age: 10, max_age: 29 },
        './circuit.wasm',
        './circuit_final.zkey'
    );

    console.log("Proof: ",proof);
    console.log(publicSignals);
    const pSignal = ['1'];
    console.log(pSignal);

    const vKey = JSON.parse(fs.readFileSync("verification_key.json"));
    const result = await snarkjs.groth16.verify(vKey, pSignal, proof);
    console.log(result);

    if (result === true) {
        console.log("Verification OK");
    } else {
        console.log("Invalid proof");
    }

    res.json(result);
});

app.post('/post-file', async (req, res) => {
    const age = parseInt(req.body.inputValue);
    const min_age = parseInt(req.body.minAge);
    const max_age = parseInt(req.body.maxAge);

    console.log("Received data:", age);

    try {
const { proof, publicSignals } = await snarkjs.groth16.fullProve(
  { age, min_age, max_age },
  "./circuit.wasm",
  "./circuit_final.zkey"
);

        const pSignal = ['1']; 
        console.log("Public Signal:", proof);

        const vKey = JSON.parse(fs.readFileSync("verification_key.json"));
        // const result = await snarkjs.groth16.verify(vKey, pSignal, proof);
        const result = await snarkjs.groth16.verify(vKey, publicSignals, proof);
        console.log("Verification result:", result);

        if (result === true) {
            console.log("Verification OK");
            res.status(200).json({
                success: true,
                message: 'Proof verification successfull!',
            });
        } else {
            console.log("Invalid proof");
            res.status(400).json({
                success: false,
                message: 'Proof verification failed!',
            });
        }
    } catch (error) {
        console.error("Error during proof generation:", error);
        res.status(500).json({
            success: false,
            message: 'An error occurred during proof generation.',
        });
    }
});



app.listen(3001, () => {
    console.log('Server running on port 3000');
});
