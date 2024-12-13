# STA CAlls in OpenRoad flow

## 1 Initial Floorplan

`flow/scripts/resize.tcl:34`
repair_design {*}$additional_args

## 2 Global Placement

`tools/OpenROAD/src/gpl/src/nesterovPlace.cpp:434`
execute resizer for reweighting nets (during placement iterations)

```cpp
bool shouldTdProceed = tb_->updateGNetWeights(average_overflow_);
```

estimate wire parasitics
report metrics.tcl

## 3 Detailed Placement
