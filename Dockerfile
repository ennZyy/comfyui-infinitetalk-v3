# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG HF_TOKEN=""

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail ComfyUI-WanVideoWrapper@058286fc0f3b0651a2f6b68309df3f06e8332cc0 --mode remote
RUN comfy node install --exit-on-fail comfyui-kjnodes@e435e999e4b1a828a6b5f6d8f037e66f4a798324
RUN comfy node install --exit-on-fail ComfyUI-MelBandRoFormer@b68d9077815387b64d596f8c39607052b95b6eba
RUN comfy node install --exit-on-fail comfyui-videohelpersuite@0a75c7958fe320efcb052f1d9f8451fd20c730a8

# download models into comfyui
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/InfiniteTalk/Wan2_1-InfiniTetalk-Single_fp16.safetensors' --relative-path models/diffusion_models --filename 'wav2vec2-chinese-base_fp16.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors' --relative-path models/clip_vision --filename 'clip_vision_h.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors' --relative-path models/text_encoders --filename 'umt5_xxl_fp8_e4m3fn_scaled.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/denisbalon/melbandroformer-fp32.safetensors/resolve/main/MelBandRoformer_fp32.safetensors' --relative-path models/diffusion_models --filename 'MelBandRoformer_fp32.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/denisbalon/wan2-1-infinitetalk-single-fp8-e4m3fn-scaled-kj.safetensors/resolve/main/Wan2_1-InfiniteTalk-Single_fp8_e4m3fn_scaled_KJ.safetensors' --relative-path models/diffusion_models --filename 'Wan2_1-InfiniteTalk-Single_fp8_e4m3fn_scaled_KJ.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors' --relative-path models/Unknown --filename 'lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-480P_fp8_e5m2.safetensors' --relative-path models/diffusion_models --filename 'Wan2_1-I2V-14B-480p_fp8_e5m2_scaled_KJ.safetensors'
RUN HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors' --relative-path models/vae --filename 'wan_2.1_vae.safetensors'

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/freepik__use-img1-as-the-base-replace-the-scene-with-a-brig__34280.jpeg' "https://cool-anteater-319.convex.cloud/api/storage/1c588fd5-da50-4f2e-bcb0-be1e6a4a7068"
