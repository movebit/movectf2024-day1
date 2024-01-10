module zk::zk1 {
    use sui::groth16;
    use sui::event;
    use sui::tx_context;

    struct Flag has copy, drop {
        user: address
    }

    public entry fun verify_proof(public_inputs_bytes: vector<u8>, proof_points_bytes: vector<u8>, ctx: &mut tx_context::TxContext) {
        let vk = x"1c1c238716cd6590311bedba30ed79290562d1402ff126f9b7ca556791fbbc178d8c74d3e06fbc02c389fee4ef2b6f574820030702a4d650d867ac7a72a2e12cb566ee9689fb32124e878f52230afec3022dfebd5b1c97dd7ad562feceb8b126219b15811e85812d9dddde26d77fda0334bc2659f8e49c89d828282b8b872b1fe37910e0c0711e895da6bf9292c85ed9cf5df3f601e11ce7f19b14672ae8cbabfd2f0aafc7f1c3b75f16807e9ac8192611f3eeaf5c8e807ea5810c56b8077227fdc90c1f63026e8653cc108fd5eab9720e846f13a410ed3a1f2ed13024aa429202000000000000008dff68fcfdf3431c290d1996d7c69795216a04baa54c24fd2efa1fe8f17ea9ae4f92e38427ceef4291965e8abf3ad0c265e82abc0d3f0153d225bcb77990b38a";
        let pvk = groth16::prepare_verifying_key(&groth16::bn254(), &vk);
        let public_inputs = groth16::public_proof_inputs_from_bytes(public_inputs_bytes);
        let proof_points = groth16::proof_points_from_bytes(proof_points_bytes);
        assert!(groth16::verify_groth16_proof(&groth16::bn254(), &pvk, &public_inputs, &proof_points), 0);
        event::emit(Flag { user: tx_context::sender(ctx) });
    }
}