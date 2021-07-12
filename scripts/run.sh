mkdir -p log
now=$(date +"%Y%m%d_%H%M")

root_dir=/mnt/lustre/$(whoami)
project_dir=$root_dir/playground/HeteroFL

export PYTHONPATH=$PYTHONPATH:${project_dir}

fraction=$1 #
if [ -z "$1" ]
  then
    fraction=0.1
fi

srun -u --partition=innova --job-name=${fraction}-heterofl \
    -n1 --gres=gpu:1 --ntasks-per-node=1 \
    python ${project_dir}/src/train_classifier_fed.py \
      --data_name CIFAR10 --model_name resnet18 \
      --control_name 1_100_${fraction}_non-iid-2_dynamic_a1-b1-c1-d1-e1_gn_0_0 2>&1 | tee log/users_${fraction}-${now}.log &
