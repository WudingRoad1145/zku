circom merkle.circom --r1cs --wasm -- sym --c

node merkle_js/generate_witness.js merkle_js/merkle.wasm input.json witness.wtns

#use snarkjs to generate and validate a proof
#groth16 zk-snark requires a trusted setup
#1. powers of tau
#witness
#ceremony
snarkjs powersoftau new bn128 14 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First Contribution" -v

#2. phase 2
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
#generate zkey
snarkjs groth16 setup merkle.r1cs pot12_final.ptau merkle_0000.zkey
snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="1st Contributor Name" -v
#export key to json file
snarkjs zkey export verificationkey merkle_0001.zkey verification_key.json
#generate zk proof using the zkey and witness
#output a proof file and a public file containing public inputs and outputs
snarkjs groth16 prove merkle_0001.zkey witness.wtns proof.json public.json
#use the verification key, proof and public file to verify if proof is valid
snarkjs groth16 verify verification_key.json public.json proof.json
