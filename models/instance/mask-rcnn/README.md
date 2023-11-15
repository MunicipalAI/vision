# Info
## Docker Image: 
tensorflow/tensorflow_1.15.4-gpu-py3
## GPU: 
3090
## Command:
sh setup.sh
## Outcome: 
Installing nvidia-tensorflow was giving me a hard time and without it a 3090 series won't work with tensorflow 1.15.4. It should work with a v100, but couldn't find one on vast.ai. 

## Citations

```
@article{He_2017,
   title={Mask R-CNN},
   journal={2017 IEEE International Conference on Computer Vision (ICCV)},
   publisher={IEEE},
   author={He, Kaiming and Gkioxari, Georgia and Dollar, Piotr and Girshick, Ross},
   year={2017},
   month={Oct}
}
```
