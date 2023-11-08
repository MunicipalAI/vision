#Install debian/ubuntu packages
apt install wget zip unzip git python3-opencv -y

#Download data
cd data
sh getData.sh
cd ../

#Install custom python libraries
pip install -r requirements.txt

#Download library
git clone https://github.com/matterport/Mask_RCNN.git

#Setup library
cd Mask_RCNN
pip install -r requirements.txt
python setup.py install

#Download pre-trained model
wget -O mask_rcnn_coco.h5 https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5

#Move data around
mkdir dataset
mkdir dataset/images/
mkdir dataset/annotations/
mv ../data/data/train/* dataset/images/
mv ../data/data/val/* dataset/images/
mv -f ../data/instances_train2017.json dataset/annotations/instances_train.json
mv -f ../data/instances_val2017.json dataset/annotations/instances_val.json

#Move custom files around
mv -f ../files/vrne.py ./
mv -f ../train.sh ./
mv -f ../files/utils.py mrcnn/

cd ../
#Install custom python libraries
pip uninstall tensorflow tensorflow-gpu keras -y
pip install -r requirements.txt

cd Mask_RCNN
sh train.sh