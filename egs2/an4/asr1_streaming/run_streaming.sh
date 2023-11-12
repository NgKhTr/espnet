#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

asr_config=conf/train_asr_streaming_transformer.yaml
inference_config=conf/decode_asr_streaming.yaml
bpe_train_text=dump/raw/train_sp/text
lm_config=conf/train_lm.yaml
use_lm=true
use_wordlm=false

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh \
    --use_streaming true \
    --lang en \
    --audio_format flac \
    --feats_type raw \
    --token_type bpe \
    --nbpe 500 \
    --use_lm ${use_lm} \
    --use_word_lm ${use_wordlm} \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --lm_config "${lm_config}" \
    --speed_perturb_factors "${speed_perturb_factors}" \
    --train_set "train_nodev" \
    --valid_set "train_dev" \
    --test_sets "train_dev test" \
    --bpe_train_text "dump/raw/train_nodev_sp/text" \
    --lm_train_text "data/train_nodev_sp/text" "$@"
