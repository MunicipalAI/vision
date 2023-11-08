_base_ = [
    '../../configs/swin/cascade_mask_rcnn_swin_small_patch4_window7_mstrain_480-800_giou_4conv1f_adamw_3x_coco.py'
]

model = dict(
    backbone=dict(
        type='CBSwinTransformer',
    ),
    neck=dict(
        type='CBFPN',
    ),
    test_cfg = dict(
        rcnn=dict(
            score_thr=0.001,
            nms=dict(type='soft_nms'),
        )
    )
)

img_norm_cfg = dict(
    mean=[123.675, 116.28, 103.53], std=[58.395, 57.12, 57.375], to_rgb=True)

# augmentation strategy originates from HTC
train_pipeline = [
    dict(type='LoadImageFromFile'),
    dict(type='LoadAnnotations', with_bbox=True, with_mask=True),
    dict(type='RandomFlip', flip_ratio=0.5),
    dict(
        type='Resize',
        img_scale=[(1600, 400), (1600, 1400)],
        multiscale_mode='range',
        keep_ratio=True),
    dict(type='Normalize', **img_norm_cfg),
    dict(type='Pad', size_divisor=32),
    dict(type='DefaultFormatBundle'),
    dict(type='Collect', keys=['img', 'gt_bboxes', 'gt_labels', 'gt_masks']),
]
test_pipeline = [
    dict(type='LoadImageFromFile'),
    dict(
        type='MultiScaleFlipAug',
        img_scale=(1600, 1400),
        flip=False,
        transforms=[
            dict(type='Resize', keep_ratio=True),
            dict(type='RandomFlip'),
            dict(type='Normalize', **img_norm_cfg),
            dict(type='Pad', size_divisor=32),
            dict(type='ImageToTensor', keys=['img']),
            dict(type='Collect', keys=['img']),
        ])
]

samples_per_gpu=1
data = dict(samples_per_gpu=samples_per_gpu,
            train=dict(pipeline=train_pipeline),
            val=dict(pipeline=test_pipeline),
            test=dict(pipeline=test_pipeline))
optimizer = dict(lr=0.0001*(samples_per_gpu/2))

# Modify dataset related settings
dataset_type = 'COCODataset'
classes = ('Homeless',
                    'Trash',
                    'Graffiti',
                    'Democrat Political Sign',
                    'Trash Can',
                    'Recycle Bin',
                    'Broken Window',
                    'Broken Gutter',
                    'Well Maintained Flower Bed',
                    'Bad Fence',
                    'Under Construction',
                    'Short Grass',
                    'Vegetation',
                    'Poorly Maintained Flower Beds',
                    'Tall Grass',
                    'Dead Tree',
                    'Car',
                    'Abandoned Car',
                    'Person',
                    'Stop Sign',
                    'Peeling Paint',
                    'High Quality Home',
                    'Medium Quality Home',
                    'Low Quality Home',
                    'Overgrown Powerline',
                    'Pothole',
                    'Republican Political Sign',
                    'Normal Powerlines',
                    'Normal Window',
                    'Leaves',
                    'Nice Fence',
                    'Confederate Flag')
data = dict(
    train=dict(
        img_prefix='dataset/images/',
        classes=classes,
        ann_file='dataset/annotations/instances_train.json'),
    val=dict(
        img_prefix='dataset/images/',
        classes=classes,
        ann_file='dataset/annotations/instances_val.json'),
    test=dict(
        img_prefix='dataset/images/',
        classes=classes,
        ann_file='dataset/annotations/instances_val.json'),
        )