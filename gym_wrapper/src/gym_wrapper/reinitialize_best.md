<!-- best models per run for reinitializations

run61.pure_speed = run-20211021_143500-1wbli8lg
terminal 1

run62.octree = run-20211021_143815-r46grtxa
terminal 2

run63.voxel = run-20211021_144107-c6iydiwe
terminal 3

run64.shortest = run-20211021_144354-2yqdg2h9
terminal 4

=========================== visual obs ON ===================
run65.objdetector = terminal 5
run66.curiosity = terminal 6
run67.entropy = terminal 7

===========================
runID=""; 

cd /app/baseAgents/test/; python /app/main.py
  "reinitialize_from": "/app/baseAgents/test/wandb/run-20211026_131328-test-1026-131326/",
  "reinitialize_from": "/app/baseAgents/test/wandb/run-20211026_153113-test-1026-153111/", << REINIT FROM THIS ONE, ALL THE FUTURE OTHER ONES (base movement logic)

>> resume the first one from the second one
resume_run_id = test-1026-144959


  "reinitialize_from": "/app/baseAgents/run61.speed/wandb/run-20211025_103347-run61.speed-1025-103345", -->

# Daily Updates
## oct 26
- `cd /app/baseAgents/run61.speed/; python /app/main.py`
- `cd /app/baseAgents/run62.octree/; python /app/main.py`

## oct 27 
- `cd /app/baseAgents/run63.voxel/; python /app/main.py`
- `cd /app/baseAgents/run64.shortest/; python /app/main.py`
- `cd /app/baseAgents/run65.detector/; python /app/main.py`

## oct 28 
- [crashed] `cd /app/baseAgents/run63.voxel/; python /app/main.py`
- [crashed] `cd /app/baseAgents/run64.shortest/; python /app/main.py`
- fix by splitting training in 3 subdivisions
- `cd /app/baseAgents/run63.voxel/; python /app/main.py`
- `cd /app/baseAgents/run64.shortest/; python /app/main.py`

- `cd /app/baseAgents/run66.curiosity/; python /app/main.py`
- `cd /app/baseAgents/run67.entropy/; python /app/main.py`
- `cd /app/baseAgents/run68.ultron/; python /app/main.py`

- [crashed] `cd /app/baseAgents/run64.shortest/; python /app/main.py`
- [crashed] `cd /app/baseAgents/run68.ultron/; python /app/main.py`

- [canceled based on error of subdivision] `cd /app/baseAgents/run64.shortest/; python /app/main.py`
- [canceled based on error of subdivision] `cd /app/baseAgents/run68.ultron/; python /app/main.py`
- [moved on to train with mlagents command line, enough data has been collected to compare performance to gym]

## oct 28, afternoon
- ✅ [windows and linux] `cd /app/baseAgents/mlagents; runID="run61.speed"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5010`
- ✅ [windows and linux] `cd /app/baseAgents/mlagents; runID="run62.octree"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5015`

## oct 29
- ✅ [windows] `cd /app/baseAgents/mlagents; runID="run63.voxel"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5020` 
- ✅ [linux] `cd /app/baseAgents/mlagents; runID="run64.shortest"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5025`
- ✅ [linux] `cd /app/baseAgents/mlagents; runID="run65.detector"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5030`

## oct 30
- ✅ [windows] `cd /app/baseAgents/mlagents; runID="run66.curiosity"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5035`
- ✅ [linux] `cd /app/baseAgents/mlagents; runID="run67.entropy"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5040`

## nov 1st
- ✅ [linux] `cd /app/baseAgents/mlagents; runID="run68.ultron"; mlagents-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5045`
- ✅ [linuxConfigLoader] `cd /app/baseAgents/mlagents; runID="run68"; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5045`
- ✅ [windows] develop config file for behaviors and rewards

## nov 2
- ✅ [-----] message remo to get more machines
- ✅ [-----] reduce project (archive old files)
- ✅ [linux] make config files for 63++025 63++05 63++075 63++1
- ✅ [linux] `cd /app/baseAgents/mlagents; runID="run63++.voxel"; mlagents1-learn config/DroneIndependent.yaml --env ../$runID/build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5020`
- ✅ [+++++] corrections gio
- ✅ [windows] 63++025 
- ✅ [gapu-t2] `runID="run63++050"; cd /app/baseAgents/mlagents; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t2] `runID="run63++075"; cd /app/baseAgents/mlagents; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5005 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t3] `runID="run63++100"; cd /app/baseAgents/mlagents; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5010 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t3] `runID="run68++100"; cd /app/baseAgents/mlagents; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5015 & wait; echo "$runID has finished" >> runs_progress.log &`   
- ✅ [windows >> gapu-t3] `cd /app/baseAgents/mlagents; runID="run68++"; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5015 &; wait; echo "$runID has finished" >> runs_progress.log &`   

## nov 3
- ✅ [gapu-t1] `runID="run63"; cd /app/baseAgents/mlagents; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t2] `runID="run66"; cd /app/baseAgents/mlagents; mlagents-learn config/$runID.yaml --env ../configLoader/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5040 & wait; echo "$runID has finished" >> runs_progress.log `   
- ✅ [-----] corrections gio: chapter 1
- ✅ [-----] corrections gio: chapter 2
- ✅ [-----] define voxel reward preferred, decisions >> 63++0.75 == 63++100 
- ✅ look into errors from ObjectsDetected metric >> bug in code was here : if (voxelsInFOV && m_detections.Count > 0)

### [windows] get environment 71 functional and ready to export with configLoaderOpenWorld
- ✅ test drop objects on top of terrain
- ✅ test maximum distance
- ✅ fix config loading to work without config (test/dev mode) >> except 
- ✅ observations vector: increased from 40 to 46
- ✅ added obs outsideBounds
- ✅ added obs distToOrigin

## nov 4
- ✅ [-----] figure out why the trees are not clickable >> terrain does not load scripts
- ✅ [-----] figure out same for rocks instances >> terrain does not load scripts
- ✅ [-----] look at error of GPU leak >> add destructor ~OD()
- ✅ [windows] export env CL_v2 (linux) and test "run68.testOD" (cannot reinitialize cause increased size of obs)
- ✅ [gapu-t2] `runID="run65"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t2] `runID="run66" && cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5005 & wait; echo "$runID has finished" >> runs_progress.log &   `

- ✅ [gapu-t1] `runID="run67"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5010 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t1] `runID="run68"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5015 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t3] `runID="run68++050"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5020 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t3] `runID="run68++100"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5025 & wait; echo "$runID has finished" >> runs_progress.log &   `


## nov 5 [WFH]
- ✅ [windows] fix errors with OD
- ✅ [windows] `$runID="test"; mlagents-learn config\test.yaml --env build\mse-dreamscape --run-id=ExplorerDrone.${runID} --force --width=1080 --height=684 --time-scale=10`


- ✅ [gapu-t2] `runID="run65"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t2] `runID="run66" && cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5005 & wait; echo "$runID has finished" >> runs_progress.log &   `

- ✅ [gapu-t1] `runID="run67"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5010 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t1] `runID="run68"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5015 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t3] `runID="run68++050"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5020 & wait; echo "$runID has finished" >> runs_progress.log &   `
- ✅ [gapu-t3] `runID="run68++100"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --num-envs=5 --force --base-port=5025 & wait; echo "$runID has finished" >> runs_progress.log &   `


## nov 6
## nov 7
- wasted because of error with OD > linux doesnt work


## nov 8
- [windows] make a backup scene CL_WithterrainTrees > 
- [windows] delete trees > put them by hand :)
- [windows] add obstacle tags to rocks

- [windows] test gridsensor visibility

- [windows] export env CL_OW 
- [windows] export run configLoaderOpenWorld 
- train_off.bat 71
- train_off.bat 72
- meeting with remo

- voxelize house
- voxelize crooked bus

## nov 9 
- [-----] corrections gio: chapter 2
- [-----] corrections gio: chapter 2


- [gapu-t1] 71
- [gapu-t1] 72
- [gapu-t2] 73
- [gapu-t2] 74
- [gapu-t3] 75
- [gapu-t3] 76

- [gapu-t1] 77
- [gapu-t1] 78


## nov 10-11

- [-----] corrections gio: chapter 3
- [-----] chapter 3

## nov 12-13
- [-----] chapter 4


## nov 13-14
- [-----] chapter 5

## nov 14
- [-----] chapter 6
- [windows] export runForest
- [windows] export runFire
- [windows] runForest
- [windows] runFire

## nov 12
- [-----] send for corrections [adhi, irena, bruno, alAmeen]


## nov 15
[-----] meeting thilo

## nov 16
[-----] PPT


## nov 17
[-----] corrections bruno
[-----] corrections adhi
[-----] corrections irena

## nov 20
[-----] send for corrections [gio, andy, moha]
[-----] correct PPT

## nov 25-27
[-----] corrections [gio, andy, moha]

## nov 27
[-----] send to thilo [PDF, PPT]

## nov 29
[-----] meeting thilo and corrections

## dec 1
[-----] define presentation date

## archive
- `runID="run61"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run62"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run63"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run63++025"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run63++050"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run63++075"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run63++100"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `
- `runID="run64"; cd /app/baseAgents_v2; mlagents-learn config/$runID.yaml --env build/agent --run-id=$runID --width=1080 --height=684 --time-scale=50 --no-graphics --num-envs=5 --force --base-port=5000 & wait; echo "$runID has finished" >> runs_progress.log &   `

