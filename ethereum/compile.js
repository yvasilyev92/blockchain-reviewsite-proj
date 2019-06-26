const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

// Delete entire build folder.
const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

// Read 'Business.sol' from 'contracts' folder.
const campaignPath = path.resolve(__dirname, 'contracts', 'Business.sol');
const source = fs.readFileSync(campaignPath, 'utf8');

// Compile both BusinessFactory, Business, & Review contracts with solidity compiler
const output = solc.compile(source,1).contracts;

// Check if directory exists, if not then create. Write output to the 'build' directory.
fs.ensureDirSync(buildPath);

// loop over compiled output object and take each contract that exists inside it & write it to a different file inside of 'build'. 
for (let contract in output) {
    // write out a json file to some specified directory (remove the colon from the start)
    fs.outputJSONSync(path.resolve(buildPath, contract.replace(":",'') + '.json'),output[contract]);
}