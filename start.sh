#!/bin/bash

# 第一引数でモデルタイプを指定（例: "yolo" または "retinanet"）
model_type=$1

# モデルの種類に応じて条件分岐
if [ "$model_type" = "yolo" ]; then
    # YOLOモデル用のコマンド
    label-studio-ml start projects/LabelStudio/backend_template \
        --with config_file=configs/yolox/yolox_s_8xb8-80e_stenosis.py \
        checkpoint_file=checkpoints/yolox_s_8xb8-80e_stenosis/epoch_80.pth \
        device=cuda:0 --port 8003 > /dev/null 2>&1 &
elif [ "$model_type" = "retinanet" ]; then
    # RetinaNetモデル用のコマンド
    label-studio-ml start projects/LabelStudio/backend_template \
        --with config_file=configs/retinanet/retinanet_r50_fpn_1x-e20_stenosis \
        checkpoint_file=checkpoints/retinanet_r50_fpn_1x-e20_stenosis/epoch_20.pth \
        device=cuda:0 --port 8003 > /dev/null 2>&1 &
else
    echo "Error: Invalid model type specified. Use 'yolo' or 'retinanet'."
    exit 1
fi

# Label Studioの起動
label-studio start --port 8004 --data-dir data
