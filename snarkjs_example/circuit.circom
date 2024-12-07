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
