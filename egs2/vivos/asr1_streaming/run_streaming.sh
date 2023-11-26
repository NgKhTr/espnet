#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

asr_config=conf/train_asr_streaming_transformer.yaml
inference_config=conf/decode_asr_streaming.yaml
lm_config=conf/train_lm.yaml
use_lm=true
use_wordlm=false

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh \
    --use_streaming true \
    --lang vi \
    --audio_format wav \
    --feats_type raw \
    --token_type char \
    --use_lm ${use_lm} \
    --use_word_lm ${use_wordlm} \
    --word_vocab_size 7184 \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --lm_config "${lm_config}" \
    --train_set "train_nodev" \
    --valid_set "train_dev" \
    --test_sets "train_dev test" \
    --lm_train_text "data/train_nodev/text" "$@"
    # --speed_perturb_factors "${speed_perturb_factors}" \
    # --nbpe 139 \
