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

srun -u --partition=innova --job-name=${fraction}-wiki-heterofl \
    -n1 --gres=gpu:1 --ntasks-per-node=1 \
    python ${project_dir}/src/test_transformer_fed.py \
      --data_name WikiText2 --model_name transformer \
      --control_name 1_100_${fraction}_iid_fix_a2-b2-c2-d2-e2_none_1_0 2>&1 | tee log/wiki_test_${fraction}-${now}.log &
