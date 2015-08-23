#!/bin/bash

# algorithm, run with jikesrvm different times with different thread counts and possible different cores

Jikesrvm=/home/jqian/projects/jvm_cache_management/work-folder/jikesrvm-3.1.3-10723/dist/working/production_x86_64-linux/rvm

python ../set_cpus.py 0

Dacapo=/home/jqian/projects/jvm_cache_management/work-folder/dacapo-9.12-rc1-bach.jar

declare -A dacapobenchmark
dacapobenchmark=(["luindex"]="72m" ["jython"]="180m" ["lusearch"]="96m" ["pmd"]="159m" ["sunflow"]="72m" ["avrora"]="96m" ["xalan"]="180m")

for core in 0 1 3 7
do
  if [ $core -gt 0 ]
  then
  python ../set_cpus.py 0-$core
  fi
  for name in "${!dacapobenchmark[@]}"
  do
   for i in {0..10}
   do
    for thread in 1 2 4 8 16 32 48 64
    do
      set -x
      $Jikesrvm -Xmx${dacapobenchmark["$name"]} -Xms${dacapobenchmark["$name"]} -jar $Dacapo $name -t $thread &>> $name-$core-$thread
      sleep 20
      set +x
      echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $name-$core-$thread
      done
    done
  done
done

