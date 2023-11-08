#Install debian/ubuntu packages
apt install wget zip unzip git python3-opencv -y

#Install custom python libraries
pip install -r requirements.txt
pip install mmcv-full==1.4.0 -f https://download.openmmlab.com/mmcv/dist/114/torch1.9.0/index.html

#Download Data
cd data
sh getData.sh
cd ../

#Download Library
git clone https://github.com/VDIGPKU/CBNetV2.git
cd CBNetV2
mkdir -p dataset
mkdir -p dataset/images
mkdir -p dataset/annotations
mkdir -p dataset/configs

#Move custom files around
mv ../files/vrne.py dataset/configs/vrne.py
mv ../files/coco_instance.py configs/_base_/datasets/coco_instance.py
mv ../files/cascade_mask_rcnn_swin_fpn.py configs/_base_/models/cascade_mask_rcnn_swin_fpn.py
mv ../files/cascade_mask_rcnn_swin_small_patch4_window7_mstrain_480-800_giou_4conv1f_adamw_3x_coco.py configs/swin/cascade_mask_rcnn_swin_small_patch4_window7_mstrain_480-800_giou_4conv1f_adamw_3x_coco.py

#Move data around
mv ../data/data/train/* dataset/images/
mv ../data/data/val/* dataset/images/
mv ../data/instances_train2017.json dataset/annotations/instances_train.json
mv ../data/instances_val2017.json dataset/annotations/instances_val.json

#Install cbnetv2 requirements
pip install -r requirements.txt
python setup.py install

#Dowload pre-trained model
wget https://github.com/CBNetwork/storage/releases/download/v1.0.0/htc_cbv2_swin_base22k_patch4_window7_mstrain_400-1400_giou_4conv1f_adamw_20e_coco.pth.zip
unzip htc_cbv2_swin_base22k_patch4_window7_mstrain_400-1400_giou_4conv1f_adamw_20e_coco.pth.zip
rm htc_cbv2_swin_base22k_patch4_window7_mstrain_400-1400_giou_4conv1f_adamw_20e_coco.pth.zip

#Install custom packages
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcusparse-11-2_11.4.1.1152-1_amd64.deb
dpkg -i libcusparse-11-2_11.4.1.1152-1_amd64.deb 

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcusparse-dev-11-2_11.4.1.1152-1_amd64.deb
dpkg -i libcusparse-dev-11-2_11.4.1.1152-1_amd64.deb 

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcublas-11-2_11.4.1.1043-1_amd64.deb
dpkg -i libcublas-11-2_11.4.1.1043-1_amd64.deb

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcublas-dev-11-2_11.4.1.1043-1_amd64.deb
dpkg -i libcublas-dev-11-2_11.4.1.1043-1_amd64.deb

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcusolver-dev-11-2_11.1.0.152-1_amd64.deb
dpkg -i libcusolver-dev-11-2_11.1.0.152-1_amd64.deb

#Upgrade pip
python -m pip install --upgrade pip

#Install apex
export CUDA_HOME=/usr/local/cuda-11.2
git clone https://github.com/NVIDIA/apex.git -b 22.04-dev
cd ./apex
pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" ./
cd ../

#train
tools/dist_train.sh dataset/configs/vrne.py 1