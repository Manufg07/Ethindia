# 1. Setup the Environment
Install Circom 
```
npm install -g circom
```
```
git clone https://github.com/iden3/circom.git
cd circom
```

```
git checkout tags/v2.1.4
```

```
cargo build --release
sudo cp target/release/circom /usr/local/bin/
```

Install Snarkjs
```
npm install -g snarkjs
```
# 2. Create Folder snarkjs_example
```
mkdir snarkjs_example
cd snarkjs_example
```
# 4. Create a circom code called circuit.circom (below code is for age proof )
```
pragma circom 2.1.0;

template AgeRangeCheck() {
    signal input age;         // Prover's age
    signal input min_age;     // Minimum age
    signal input max_age;     // Maximum age
    signal output isValid;    // Output: 1 if age is within range, else 0

    // Calculate differences
    signal diffMin;           // Difference for min age check
    signal diffMax;           // Difference for max age check

    diffMin <== age - min_age;
    diffMax <== max_age - age;

    // Binary signal for age >= min_age
    signal isGreaterOrEqual;
    signal nonNegativeDiffMin;

    // Initialize nonNegativeDiffMin to simulate the check if diffMin >= 0
    nonNegativeDiffMin <-- diffMin >= 0 ? 1 : 0;  // Simulate age >= min_age
    isGreaterOrEqual <== nonNegativeDiffMin;       // Set isGreaterOrEqual based on the result

    // Binary signal for age <= max_age
    signal isLessOrEqual;
    signal nonNegativeDiffMax;

    // Initialize nonNegativeDiffMax to simulate the check if diffMax >= 0
    nonNegativeDiffMax <-- diffMax >= 0 ? 1 : 0;  // Simulate age <= max_age
    isLessOrEqual <== nonNegativeDiffMax;         // Set isLessOrEqual based on the result

    // Final output: isValid = isGreaterOrEqual AND isLessOrEqual
    isValid <== isGreaterOrEqual * isLessOrEqual;
}

component main = AgeRangeCheck();

```
# 5. Create input.json file for test and compile
```
{ age: 9, min_age: 10, max_age: 29 }
```

## Refer this Link to Create circom code and generate verification key and proof
```
https://github.com/iden3/snarkjs
```

## circom Language document
```
https://docs.circom.io/circom-language/signals/
```
### 6. Run start.sh file for Setup snarkjs 
### 7. Run circuitstart.sh file for generate zkey,proof,verification key,wasm
## 8. Create Backend and initialize node
```
mkdir backend
cd backend
```
```
npm init
npm install express snarkjs cors fs
```
#### Copy the following file and paste to the backend folder
    1. proof.json
    2. circuit.wasm
    3. circuit_final.zkey
    4. public.json
###  Create index.js and import snarkjs,fs,cors,express
#### code
```
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
        const { proof } = await snarkjs.groth16.fullProve(
            { age, min_age, max_age },
            './circuit.wasm',
            './circuit_final.zkey'
        );

        const pSignal = ['1']; 
        console.log("Public Signal:", proof);

        const vKey = JSON.parse(fs.readFileSync("verification_key.json"));
        const result = await snarkjs.groth16.verify(vKey, pSignal, proof);
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



app.listen(3000, () => {
    console.log('Server running on port 3000');
});
```
### Start Node
```
node index.js
```
### To Test the API, Call it from postman
```
http://localhost:3000/read-file

```
