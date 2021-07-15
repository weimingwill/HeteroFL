mkdir -p log
now=$(date +"%Y%m%d_%H%M")

root_dir=/mnt/lustre/$(whoami)
project_dir=$root_dir/playground/HeteroFL

export PYTHONPATH=$PYTHONPATH:${project_dir}

fraction=$1
if [ -z "$1" ]
  then
    fraction=0.1
fi

fix=$2
if [ -z "$2" ]
  then
    fix=a5-e5
fi


srun -u --partition=innova --job-name=${fraction}-${fix}-cifar-heterofl \
    -n1 --gres=gpu:1 --ntasks-per-node=1 \
    python ${project_dir}/src/train_classifier_fed.py \
      --data_name CIFAR10 --model_name resnet18 \
      --control_name 1_100_${fraction}_non-iid-fix_${fix}_gn_0_0 2>&1 | tee log/users_cifar_${fraction}-${now}.log &
