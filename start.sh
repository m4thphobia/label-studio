#!/bin/bash

label-studio-ml start projects/LabelStudio/backend_template --with config_file=configs/yolox/yolox_s_8xb8-80e_stenosis.py checkpoint_file=work_dirs/yolox_s_8xb8-80e_stenosis/epoch_80.pth device=cuda:0 --port 8003 > /dev/null 2>&1 &
label-studio start --port 8004
