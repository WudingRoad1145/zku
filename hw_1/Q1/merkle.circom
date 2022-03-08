pragma circom 2.0.3;

//use mimcsponge.circom to encrypt
include "mimcsponge.circom";

template Merekle(N) {
    signal input leaves[N];
    signal output out;
    
    component mimc = MiMCSponge(N, 220, 1);
    
    for (var i = 0; i < N; i++) {
        mimc.ins[i] <== leaves[i];
    }
    mimc.k <== 0;

    out <== mimc.outs[0];
 }
component main = Merekle(8);