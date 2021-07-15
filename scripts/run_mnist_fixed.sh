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


srun -u --partition=innova --job-name=${fraction}-${fix}-mnist-heterofl \
    -n1 --gres=gpu:1 --ntasks-per-node=1 \
    python ${project_dir}/src/train_classifier_fed.py \
      --data_name MNIST --model_name conv \
      --control_name 1_100_${fraction}_non-iid-fix_${fix}_bn_1_1 2>&1 | tee log/users_mnist_${fraction}-${now}.log &
